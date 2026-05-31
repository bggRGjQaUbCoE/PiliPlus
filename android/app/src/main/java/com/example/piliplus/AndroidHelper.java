package com.example.piliplus;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.Keep;

import com.github.dart_lang.jni_flutter.JniFlutterPlugin;

import org.jetbrains.annotations.NotNull;

@Keep
public final class AndroidHelper {
    public static volatile boolean isPipMode = false;

    public static volatile boolean isPipAvailable = false;

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
        } catch (Throwable ignored) {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

    public static void createShortcut(@NotNull String id, @NotNull String uri, @NotNull String label, @NotNull String icon) {
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
}