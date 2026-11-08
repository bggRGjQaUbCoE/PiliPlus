package com.example.piliplus;

import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Surface;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.OptIn;
import androidx.media3.common.C;
import androidx.media3.common.MediaItem;
import androidx.media3.common.PlaybackException;
import androidx.media3.common.Player;
import androidx.media3.common.VideoSize;
import androidx.media3.common.text.Cue;
import androidx.media3.common.text.CueGroup;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.datasource.DefaultDataSource;
import androidx.media3.datasource.DefaultHttpDataSource;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.exoplayer.analytics.AnalyticsListener;
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory;
import androidx.media3.exoplayer.source.MediaSource;
import androidx.media3.exoplayer.source.MergingMediaSource;
import androidx.media3.ui.PlayerView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.view.TextureRegistry;

/** Owns playback independently of the SurfaceView's layout and fullscreen lifecycle. */
@OptIn(markerClass = UnstableApi.class)
public final class NativeHdrPlayback implements FlutterPlugin {
    private static final String CHANNEL = "piliplus/native_hdr";
    private static final String TAG = "PiliNativeHDR";
    private static final long[] NETWORK_RETRY_DELAYS_MS = {1_000, 3_000, 9_000};
    private Context context;
    private MethodChannel hostChannel;
    private final Map<Integer, Session> sessions = new HashMap<>();

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        context = binding.getApplicationContext();
        binding.getPlatformViewRegistry().registerViewFactory(
                CHANNEL, new PlatformViewFactory(StandardMessageCodec.INSTANCE) {
                    @Override
                    public PlatformView create(Context viewContext, int viewId, Object args) {
                        Session session = sessions.get(((Number) args).intValue());
                        if (session == null) {
                            FrameLayout placeholder = new FrameLayout(viewContext);
                            return new PlatformView() {
                                public View getView() { return placeholder; }
                                public void dispose() {}
                            };
                        }
                        return session.createView(viewContext);
                    }
                });
        hostChannel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
        hostChannel.setMethodCallHandler((call, result) -> {
            if (!call.method.equals("create")) {
                result.notImplemented();
                return;
            }
            int id = call.<Integer>argument("id");
            boolean useTexture = Boolean.TRUE.equals(call.argument("useTexture"));
            if (sessions.containsKey(id)) {
                result.error("duplicate_session", null, null);
                return;
            }
            MethodChannel channel = new MethodChannel(
                    binding.getBinaryMessenger(), CHANNEL + "/" + id);
            Session session = new Session(channel, () -> sessions.remove(id));
            try {
                if (useTexture) session.attachTexture(binding.getTextureRegistry());
                sessions.put(id, session);
                result.success(session.texture == null ? null : session.texture.id());
            } catch (RuntimeException error) {
                session.release();
                Log.e(TAG, "textureCreationFailed=" + error.getClass().getSimpleName());
                result.error("texture_creation_failed", null, null);
            }
        });
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        hostChannel.setMethodCallHandler(null);
        for (Session session : new ArrayList<>(sessions.values())) {
            session.release();
        }
        context = null;
    }

    private final class Session implements Player.Listener {
        private final MethodChannel channel;
        private final Runnable onRelease;
        private final Handler handler = new Handler(Looper.getMainLooper());
        private final ExoPlayer player = new ExoPlayer.Builder(context).build();
        private final Runnable tick = this::publishState;
        private final Runnable retryNetwork = this::retryNetworkPlayback;
        private int networkRetryCount;
        private boolean networkRetryPending;
        private MediaItem video;
        private String audio;
        private DefaultMediaSourceFactory sources;
        private MediaItem.SubtitleConfiguration subtitle;
        private PlayerView attachedView;
        private TextureRegistry.SurfaceTextureEntry texture;
        private Surface textureSurface;
        private boolean released;

        Session(MethodChannel channel, Runnable onRelease) {
            this.channel = channel;
            this.onRelease = onRelease;
            player.setHandleAudioBecomingNoisy(true);
            player.addListener(this);
            player.addAnalyticsListener(new AnalyticsListener() {
                @Override
                public void onVideoDecoderInitialized(EventTime time, String name,
                        long initializedAt, long durationMs) {
                    Log.i(TAG, "videoDecoder=" + name);
                }
            });
            channel.setMethodCallHandler(this::handle);
        }

        void attachTexture(TextureRegistry registry) {
            texture = registry.createSurfaceTexture();
            textureSurface = new Surface(texture.surfaceTexture());
            player.setVideoSurface(textureSurface);
        }

        PlatformView createView(Context viewContext) {
            PlayerView view = (PlayerView) LayoutInflater.from(viewContext)
                    .inflate(R.layout.native_hdr_player, null);
            View videoSurface = view.getVideoSurfaceView();
            if (videoSurface instanceof SurfaceView) {
                // Place video above Flutter's render surface and below its controls.
                ((SurfaceView) videoSurface).setZOrderMediaOverlay(true);
            }
            if (view.getSubtitleView() != null) view.getSubtitleView().setVisibility(View.GONE);
            PlayerView.switchTargetView(player, attachedView, view);
            attachedView = view;
            return new PlatformView() {
                public View getView() { return view; }
                public void dispose() {
                    if (attachedView == view) {
                        view.setPlayer(null);
                        attachedView = null;
                    }
                }
            };
        }

        private void handle(MethodCall call, MethodChannel.Result result) {
            try {
                switch (call.method) {
                    case "load":
                        String userAgent = call.argument("userAgent");
                        String referer = call.argument("referer");
                        DefaultHttpDataSource.Factory http = new DefaultHttpDataSource.Factory()
                                .setUserAgent(userAgent);
                        if (referer != null) {
                            http.setDefaultRequestProperties(Collections.singletonMap("Referer", referer));
                        }
                        sources = new DefaultMediaSourceFactory(new DefaultDataSource.Factory(context, http));
                        video = MediaItem.fromUri(call.<String>argument("video"));
                        audio = call.argument("audio");
                        prepare(((Number) call.argument("position")).longValue(), false);
                        break;
                    case "play":
                        if (player.getPlayerError() != null) {
                            resetNetworkRetry();
                            player.prepare();
                        }
                        if (player.getPlaybackState() == Player.STATE_ENDED) player.seekTo(0);
                        player.play();
                        break;
                    case "pause":
                        resetNetworkRetry();
                        player.pause();
                        break;
                    case "seek": player.seekTo(((Number) call.arguments).longValue()); break;
                    case "rate": player.setPlaybackSpeed(((Number) call.arguments).floatValue()); break;
                    case "volume": player.setVolume(((Number) call.arguments).floatValue()); break;
                    case "retry":
                        resetNetworkRetry();
                        player.prepare();
                        player.play();
                        break;
                    case "subtitle":
                        String uri = call.argument("uri");
                        String mimeType = call.argument("mimeType");
                        MediaItem.SubtitleConfiguration nextSubtitle = uri == null ? null
                                : new MediaItem.SubtitleConfiguration.Builder(Uri.parse(uri))
                                        .setMimeType(mimeType)
                                        .setSelectionFlags(C.SELECTION_FLAG_DEFAULT)
                                        .build();
                        if (!Objects.equals(subtitle, nextSubtitle)) {
                            subtitle = nextSubtitle;
                            channel.invokeMethod("subtitle", "");
                            prepare(player.getCurrentPosition(), player.getPlayWhenReady());
                        }
                        break;
                    case "dispose":
                        release();
                        result.success(null);
                        return;
                    default:
                        result.notImplemented();
                        return;
                }
                publishState();
                result.success(null);
            } catch (RuntimeException error) {
                Log.e(TAG, "commandFailed=" + call.method + ":" + error.getClass().getSimpleName());
                result.error("playback_command_failed", call.method, null);
            }
        }

        private void prepare(long position, boolean play) {
            resetNetworkRetry();
            MediaItem item = video.buildUpon().setSubtitleConfigurations(
                    subtitle == null ? Collections.emptyList() : Collections.singletonList(subtitle))
                    .build();
            MediaSource source = sources.createMediaSource(item);
            if (audio != null && !audio.isEmpty()) {
                source = new MergingMediaSource(source, sources.createMediaSource(MediaItem.fromUri(audio)));
            }
            player.setPlayWhenReady(play);
            player.setMediaSource(source, position);
            player.prepare();
        }

        @Override
        public void onEvents(Player ignored, Player.Events events) {
            if (player.getPlaybackState() == Player.STATE_READY || !player.getPlayWhenReady()) {
                resetNetworkRetry();
            }
            publishState();
        }

        @Override
        public void onCues(CueGroup group) {
            StringBuilder text = new StringBuilder();
            for (Cue cue : group.cues) {
                if (cue.text != null) {
                    if (text.length() > 0) text.append('\n');
                    text.append(cue.text);
                }
            }
            if (!released) channel.invokeMethod("subtitle", text.toString());
        }

        @Override
        public void onPlayerError(PlaybackException error) {
            Log.e(TAG, "playbackError=" + error.getErrorCodeName());
            if (released) return;
            boolean retryable = error.errorCode == PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_FAILED
                    || error.errorCode == PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT;
            if (retryable && player.getPlayWhenReady()
                    && networkRetryCount < NETWORK_RETRY_DELAYS_MS.length) {
                if (!networkRetryPending) {
                    networkRetryPending = true;
                    handler.postDelayed(retryNetwork, NETWORK_RETRY_DELAYS_MS[networkRetryCount++]);
                }
                return;
            }
            channel.invokeMethod("error", error.getErrorCodeName());
        }

        private void retryNetworkPlayback() {
            networkRetryPending = false;
            if (!released && player.getPlayWhenReady() && player.getPlayerError() != null) {
                // Reprepare the same source and position without changing play intent.
                player.prepare();
            }
        }

        private void resetNetworkRetry() {
            handler.removeCallbacks(retryNetwork);
            networkRetryPending = false;
            networkRetryCount = 0;
        }

        private void publishState() {
            handler.removeCallbacks(tick);
            if (released) return;
            int playbackState = player.getPlaybackState();
            VideoSize size = player.getVideoSize();
            Map<String, Object> state = new HashMap<>();
            state.put("playing", player.getPlayWhenReady() && playbackState != Player.STATE_ENDED
                    && (player.getPlayerError() == null || networkRetryPending));
            state.put("completed", playbackState == Player.STATE_ENDED);
            state.put("buffering", playbackState == Player.STATE_BUFFERING || networkRetryPending);
            state.put("position", player.getCurrentPosition());
            state.put("duration", Math.max(0, player.getDuration()));
            state.put("buffer", player.getBufferedPosition());
            state.put("width", Math.round(size.width * size.pixelWidthHeightRatio));
            state.put("height", size.height);
            channel.invokeMethod("state", state);
            if (player.isPlaying()) handler.postDelayed(tick, 100);
        }

        private void release() {
            released = true;
            resetNetworkRetry();
            handler.removeCallbacks(tick);
            channel.setMethodCallHandler(null);
            if (attachedView != null) attachedView.setPlayer(null);
            attachedView = null;
            player.release();
            if (textureSurface != null) textureSurface.release();
            if (texture != null) texture.release();
            onRelease.run();
        }
    }
}
