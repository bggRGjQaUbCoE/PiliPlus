/*
 * Copyright 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.piliplus;

import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.media.session.PlaybackState;
import android.os.Build;
import android.util.Log;
import android.view.KeyEvent;

import java.util.List;

class MediaHelper {
    private static final String TAG = "MediaButtonReceiver";

    static PendingIntent buildMediaButtonPendingIntent(Context context, ComponentName mbrComponent, int action) {
        if (mbrComponent == null) {
            Log.w(TAG, "The component name of media button receiver should be provided.");
            return null;
        }
        int keyCode = PlaybackStateCompat_toKeyCode(action);
        if (keyCode == KeyEvent.KEYCODE_UNKNOWN) {
            Log.w(TAG,
                    "Cannot build a media button pending intent with the given action: " + action);
            return null;
        }
        Intent intent = new Intent(Intent.ACTION_MEDIA_BUTTON);
        intent.setComponent(mbrComponent);
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, keyCode));
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
        return PendingIntent.getBroadcast(context, keyCode, intent,
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ? PendingIntent.FLAG_MUTABLE : 0);
    }

    private static int PlaybackStateCompat_toKeyCode(int action) {
        return switch (action) {
            case (int) PlaybackState.ACTION_STOP -> KeyEvent.KEYCODE_MEDIA_STOP;
            case (int) PlaybackState.ACTION_PAUSE -> KeyEvent.KEYCODE_MEDIA_PAUSE;
            case (int) PlaybackState.ACTION_PLAY -> KeyEvent.KEYCODE_MEDIA_PLAY;
            case (int) PlaybackState.ACTION_REWIND -> KeyEvent.KEYCODE_MEDIA_REWIND;
            case (int) PlaybackState.ACTION_SKIP_TO_PREVIOUS -> KeyEvent.KEYCODE_MEDIA_PREVIOUS;
            case (int) PlaybackState.ACTION_SKIP_TO_NEXT -> KeyEvent.KEYCODE_MEDIA_NEXT;
            case (int) PlaybackState.ACTION_FAST_FORWARD -> KeyEvent.KEYCODE_MEDIA_FAST_FORWARD;
            case (int) PlaybackState.ACTION_PLAY_PAUSE -> KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE;
            default -> KeyEvent.KEYCODE_UNKNOWN;
        };
    }

    static ComponentName getMediaButtonReceiverComponent(Context context) {
        Intent queryIntent = new Intent(Intent.ACTION_MEDIA_BUTTON);
        queryIntent.setPackage(context.getPackageName());
        PackageManager pm = context.getPackageManager();
        List<ResolveInfo> resolveInfos = pm.queryBroadcastReceivers(queryIntent, 0);
        if (resolveInfos.size() == 1) {
            ResolveInfo resolveInfo = resolveInfos.get(0);
            return new ComponentName(resolveInfo.activityInfo.packageName,
                    resolveInfo.activityInfo.name);
        } else if (resolveInfos.size() > 1) {
            Log.w(TAG, "More than one BroadcastReceiver that handles "
                    + Intent.ACTION_MEDIA_BUTTON + " was found, returning null.");
        }
        return null;
    }
}
