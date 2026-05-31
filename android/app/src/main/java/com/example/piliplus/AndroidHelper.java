package com.example.piliplus;

import android.app.Activity;
import android.app.PendingIntent;
import android.app.PictureInPictureParams;
import android.app.SearchManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Rational;
import android.view.WindowManager;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import com.github.dart_lang.jni_flutter.JniFlutterPlugin;

import java.util.ArrayList;

@Keep
public final class AndroidHelper {
    public static final boolean isFoldable;

    public static final boolean isPipAvailable;

    public static volatile boolean isPipMode = false;

    static {
        PackageManager pm = getContext().getPackageManager();
        isFoldable = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && pm.hasSystemFeature(PackageManager.FEATURE_SENSOR_HINGE_ANGLE);
        isPipAvailable = pm.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE);
    }

    private AndroidHelper() {
    }

    private static Context getContext() {
        return JniFlutterPlugin.getApplicationContext();
    }

    public static int sdkInt() {
        return Build.VERSION.SDK_INT;
    }

    public static void back() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        getContext().startActivity(intent);
    }

    public static void biliSendCommAntifraud(
            int action, long oid, int type, long rpId, long root, long parent, long ctime, @NonNull String commentText,
            String pictures, @NonNull String sourceId, long uid, @NonNull String cookie
    ) {
        Intent intent = new Intent();
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setComponent(new ComponentName(
                "icu.freedomIntrovert.biliSendCommAntifraud",
                "icu.freedomIntrovert.biliSendCommAntifraud.ByXposedLaunchedActivity"
        ));
        intent.putExtra("action", action);
        intent.putExtra("oid", oid);
        intent.putExtra("type", type);
        intent.putExtra("rpid", rpId);
        intent.putExtra("root", root);
        intent.putExtra("parent", parent);
        intent.putExtra("ctime", ctime);
        intent.putExtra("comment_text", commentText);
        if (pictures != null) {
            intent.putExtra("pictures", pictures);
        }
        intent.putExtra("source_id", sourceId);
        intent.putExtra("uid", uid);
        ArrayList<String> cookiesList = new ArrayList<>(1);
        cookiesList.add(cookie);
        intent.putStringArrayListExtra("cookies", cookiesList);
        getContext().startActivity(intent);
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
        } catch (Throwable ignored) {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

    public static boolean openMusic(@NonNull String title, String artist, String album) {
        Intent intent = new Intent(MediaStore.INTENT_ACTION_MEDIA_SEARCH);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra(SearchManager.QUERY, title);
        intent.putExtra(MediaStore.EXTRA_MEDIA_TITLE, title);
        if (artist != null) {
            intent.putExtra(MediaStore.EXTRA_MEDIA_ARTIST, artist);
        }
        if (album != null) {
            intent.putExtra(MediaStore.EXTRA_MEDIA_ALBUM, album);
        }
        intent.addCategory(Intent.CATEGORY_DEFAULT);

        Context context = getContext();
        PackageManager pm = context.getPackageManager();

        try {
            if (pm.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                context.startActivity(intent);
                return true;
            }
        } catch (Throwable ignored) {
        }

        try {
            intent.setAction(MediaStore.INTENT_ACTION_MEDIA_PLAY_FROM_SEARCH);
            if (pm.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                context.startActivity(intent);
                return true;
            }
        } catch (Throwable ignored) {
        }

        return false;
    }

    public static void enterPip(int width, int height, boolean autoEnter, long engineId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Activity activity = JniFlutterPlugin.getActivity(engineId);
            assert activity != null;
            PictureInPictureParams.Builder builder = new PictureInPictureParams.Builder()
                    .setAspectRatio(new Rational(width, height));
            if (autoEnter) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    builder.setAutoEnterEnabled(true);
                    activity.setPictureInPictureParams(builder.build());
                }
            } else {
                activity.enterPictureInPictureMode(builder.build());
            }
        }
    }

    public static void disableAutoEnterPip(long engineId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            Activity activity = JniFlutterPlugin.getActivity(engineId);
            if (activity != null) {
                activity.setPictureInPictureParams(new PictureInPictureParams.Builder()
                        .setAutoEnterEnabled(false)
                        .build()
                );
            }
        }
    }

    public static int[] maxScreenSize() {
        Context context = getContext();
        WindowManager wm = context.getSystemService(WindowManager.class);
        try {
            float density = context.getResources().getDisplayMetrics().density;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Rect maxBounds = wm.getMaximumWindowMetrics().getBounds();
                return new int[]{Math.round(maxBounds.width() / density), Math.round(maxBounds.height() / density)};
            } else {
                Point realSize = new Point();
                wm.getDefaultDisplay().getRealSize(realSize);
                return new int[]{Math.round(realSize.x / density), Math.round(realSize.y / density)};
            }
        } catch (Exception e) {
            return null;
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

    @Keep
    public static final class ToDart {
        public static volatile Runnable onUserLeaveHint;
        public static Runnable onConfigurationChanged;

        private ToDart() {
        }
    }
}