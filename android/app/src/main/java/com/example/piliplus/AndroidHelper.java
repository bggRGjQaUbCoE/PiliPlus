package com.example.piliplus;

import android.app.Activity;
import android.app.PendingIntent;
import android.app.PictureInPictureParams;
import android.app.RemoteAction;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Icon;
import android.media.session.PlaybackState;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Rational;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.DrawableRes;
import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.github.dart_lang.jni_flutter.JniFlutterPlugin;

import java.util.ArrayList;
import java.util.Objects;

@Keep
public final class AndroidHelper {
    public static volatile boolean isPipMode = false;

    public static final boolean isPipAvailable;

    static {
        PackageManager pm = getContext().getPackageManager();
        isPipAvailable = pm.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE);
    }

    private AndroidHelper() {
    }

    private static Context getContext() {
        return JniFlutterPlugin.getApplicationContext();
    }

    public static void back() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        getContext().startActivity(intent);
    }

    public static int sdkInt() {
        return Build.VERSION.SDK_INT;
    }

    public static void openLinkVerifySettings() {
        Context context = getContext();
        Uri uri = Uri.parse("package:" + context.getPackageName());
        try {
            Intent intent;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                intent = new Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS, uri);
            } else {
                intent = new Intent(Intent.ACTION_MAIN, uri);
                intent.setClassName(
                        "com.android.settings",
                        "com.android.settings.applications.InstalledAppOpenByDefaultActivity"
                );
            }
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Exception ignored) {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

    public static void createShortcut(@NonNull String id, @NonNull String uri, @NonNull String label, @NonNull String icon) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Context context = getContext();
            ShortcutManager shortcutManager = context.getSystemService(ShortcutManager.class);
            if (shortcutManager != null && shortcutManager.isRequestPinShortcutSupported()) {
                Bitmap bitmap = BitmapFactory.decodeFile(icon);
                ShortcutInfo shortcut = new ShortcutInfo.Builder(context, id)
                        .setShortLabel(label)
                        .setIcon(Icon.createWithAdaptiveBitmap(bitmap))
                        .setIntent(new Intent(Intent.ACTION_VIEW, Uri.parse(uri)))
                        .build();
                // TODO: WorkerThread
                Intent pinIntent = shortcutManager.createShortcutResultIntent(shortcut);
                PendingIntent pendingIntent = PendingIntent.getBroadcast(
                        context, 0, pinIntent, PendingIntent.FLAG_IMMUTABLE
                );
                shortcutManager.requestPinShortcut(shortcut, pendingIntent.getIntentSender());
            }
        }
    }

    public static void enterPip(long engineId, int width, int height, boolean isLive, boolean isPlaying) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Activity activity = JniFlutterPlugin.getActivity(engineId);
            assert activity != null;
            PictureInPictureParams.Builder builder = new PictureInPictureParams.Builder()
                    .setAspectRatio(new Rational(width, height));
            setPipActions(activity, builder, isLive, isPlaying);
            activity.enterPictureInPictureMode(builder.build());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public static void updatePipActions(long engineId, boolean isLive, boolean isPlaying) {
        Activity activity = JniFlutterPlugin.getActivity(engineId);
        assert activity != null;
        PictureInPictureParams.Builder builder = new PictureInPictureParams.Builder();
        setPipActions(activity, builder, isLive, isPlaying);
        activity.setPictureInPictureParams(builder.build());
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private static void setPipActions(Activity activity, PictureInPictureParams.Builder builder, boolean isLive, boolean isPlaying) {
        ComponentName mbrComponent = MediaHelper.getMediaButtonReceiverComponent(activity);
        if (mbrComponent == null) return;
        ArrayList<RemoteAction> actionList = new ArrayList<>(3);
        if (!isLive) {
            actionList.add(getRemoteAction(mbrComponent, activity, R.drawable.ic_player_rewind_10s, "ACTION_REWIND", (int) PlaybackState.ACTION_REWIND));
        }
        if (isPlaying) {
            actionList.add(getRemoteAction(mbrComponent, activity, R.drawable.ic_player_pause, "ACTION_PAUSE", (int) PlaybackState.ACTION_PAUSE));
        } else {
            actionList.add(getRemoteAction(mbrComponent, activity, R.drawable.ic_player_play, "ACTION_PLAY", (int) PlaybackState.ACTION_PLAY));
        }
        if (!isLive) {
            actionList.add(getRemoteAction(mbrComponent, activity, R.drawable.ic_player_fast_forward_10s, "ACTION_FAST_FORWARD", (int) PlaybackState.ACTION_FAST_FORWARD));
        }
        builder.setActions(actionList);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private static RemoteAction getRemoteAction(@NonNull ComponentName mbrComponent, Activity activity, @DrawableRes int resId, String title, int action) {
        return new RemoteAction(
                Icon.createWithResource(activity, resId),
                title,
                title,
                Objects.requireNonNull(MediaHelper.buildMediaButtonPendingIntent(activity, mbrComponent, action))
        );
    }

    public static void setPreferredDisplayMode(long engineId, int mode) {
        Activity activity = JniFlutterPlugin.getActivity(engineId);
        assert activity != null;
        final Window window = activity.getWindow();
        final WindowManager.LayoutParams params = window.getAttributes();
        params.preferredDisplayModeId = mode;
        window.setAttributes(params);
    }
}
