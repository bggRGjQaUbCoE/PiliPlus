package io.flutter;

import android.app.Activity;
import android.os.Build;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.core.view.WindowCompat;
import androidx.core.view.WindowInsetsControllerCompat;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;

/// from Flutter
public class SystemChrome {
    public static void onMethodCall(Activity activity, String methodName, Object arguments) {
        switch (methodName) {
            case "SystemChrome.setEnabledSystemUIMode":
                try {
                    SystemUiMode mode = decodeSystemUiMode((String) arguments);
                    setSystemChromeEnabledSystemUIMode(activity, mode);
                } catch (JSONException | NoSuchFieldException exception) {
                }
                break;
            case "SystemChrome.setEnabledSystemUIOverlays":
                try {
                    List<SystemUiOverlay> overlays = decodeSystemUiOverlays((JSONArray) arguments);
                    setSystemChromeEnabledSystemUIOverlays(activity, overlays);
                } catch (JSONException | NoSuchFieldException exception) {
                }
                break;
        }
    }


    @NonNull
    private static SystemUiMode decodeSystemUiMode(@NonNull String encodedSystemUiMode)
            throws JSONException, NoSuchFieldException {
        SystemUiMode mode = SystemUiMode.fromValue(encodedSystemUiMode);
        switch (mode) {
            case LEAN_BACK:
                return SystemUiMode.LEAN_BACK;
            case IMMERSIVE:
                return SystemUiMode.IMMERSIVE;
            case IMMERSIVE_STICKY:
                return SystemUiMode.IMMERSIVE_STICKY;
            case EDGE_TO_EDGE:
                return SystemUiMode.EDGE_TO_EDGE;
        }

        // Execution should never ever get this far, but if it does, we default to edge to edge.
        return SystemUiMode.EDGE_TO_EDGE;
    }

    public static final int DEFAULT_SYSTEM_UI =
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN;

    private static void setSystemChromeEnabledSystemUIOverlays(Activity activity, List<SystemUiOverlay> overlaysToShow) {
        // Start by assuming we want to hide all system overlays (like an immersive
        // game).

        disableEdgeToEdge(activity);

        int enabledOverlays =
                DEFAULT_SYSTEM_UI
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;

        if (overlaysToShow.isEmpty()) {
            enabledOverlays |= View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
        }

        // Re-add any desired system overlays.
        for (int i = 0; i < overlaysToShow.size(); ++i) {
            SystemUiOverlay overlayToShow = overlaysToShow.get(i);
            switch (overlayToShow) {
                case TOP_OVERLAYS:
                    enabledOverlays &= ~View.SYSTEM_UI_FLAG_FULLSCREEN;
                    break;
                case BOTTOM_OVERLAYS:
                    enabledOverlays &= ~View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION;
                    enabledOverlays &= ~View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;
                    break;
            }
        }

        mEnabledOverlays = enabledOverlays;
        updateSystemUiOverlays(activity);
    }

    @NonNull
    private static List<SystemUiOverlay> decodeSystemUiOverlays(@NonNull JSONArray encodedSystemUiOverlay)
            throws JSONException, NoSuchFieldException {
        List<SystemUiOverlay> overlays = new ArrayList<>();
        for (int i = 0; i < encodedSystemUiOverlay.length(); ++i) {
            String encodedOverlay = encodedSystemUiOverlay.getString(i);
            SystemUiOverlay overlay = SystemUiOverlay.fromValue(encodedOverlay);
            switch (overlay) {
                case TOP_OVERLAYS:
                    overlays.add(SystemUiOverlay.TOP_OVERLAYS);
                    break;
                case BOTTOM_OVERLAYS:
                    overlays.add(SystemUiOverlay.BOTTOM_OVERLAYS);
                    break;
            }
        }
        return overlays;
    }


    public enum SystemUiOverlay {
        TOP_OVERLAYS("SystemUiOverlay.top"),
        BOTTOM_OVERLAYS("SystemUiOverlay.bottom");

        @NonNull
        static SystemUiOverlay fromValue(@NonNull String encodedName) throws NoSuchFieldException {
            for (SystemUiOverlay overlay : SystemUiOverlay.values()) {
                if (overlay.encodedName.equals(encodedName)) {
                    return overlay;
                }
            }
            throw new NoSuchFieldException("No such SystemUiOverlay: " + encodedName);
        }

        @NonNull
        private String encodedName;

        SystemUiOverlay(@NonNull String encodedName) {
            this.encodedName = encodedName;
        }
    }


    private static int mEnabledOverlays;
    private static boolean isEdgeToEdge = false;
    private static SystemChromeStyle currentTheme;


    /**
     * The set of Android system fullscreen modes as perceived by the Flutter application.
     */
    public enum SystemUiMode {
        LEAN_BACK("SystemUiMode.leanBack"),
        IMMERSIVE("SystemUiMode.immersive"),
        IMMERSIVE_STICKY("SystemUiMode.immersiveSticky"),
        EDGE_TO_EDGE("SystemUiMode.edgeToEdge");

        /**
         * Returns the SystemUiMode for the provided encoded value. @throws NoSuchFieldException if any
         * of the given encoded overlay names are invalid.
         */
        @NonNull
        static SystemUiMode fromValue(@NonNull String encodedName) throws NoSuchFieldException {
            for (SystemUiMode mode : SystemUiMode.values()) {
                if (mode.encodedName.equals(encodedName)) {
                    return mode;
                }
            }
            throw new NoSuchFieldException("No such SystemUiMode: " + encodedName);
        }

        @NonNull
        private String encodedName;

        /**
         * Returns the encoded {@link SystemUiMode}
         */
        SystemUiMode(@NonNull String encodedName) {
            this.encodedName = encodedName;
        }
    }

    private static void setSystemChromeEnabledSystemUIMode(Activity activity, SystemUiMode systemUiMode) {
        int enabledOverlays;

        // If we were previously in edge-to-edge mode and are switching to a different mode,
        // restore the default window inset behavior.
        if (systemUiMode != SystemUiMode.EDGE_TO_EDGE) {
            disableEdgeToEdge(activity);
        }

        if (systemUiMode == SystemUiMode.LEAN_BACK) {
            // LEAN BACK
            // Available starting at Android SDK 4.1 (API 16).
            //
            // If the Flutter Android app targets Android SDK 15 (API 35), then the Android
            // system will ignore this value unless the app also follows the opt out
            // instructions found in
            // https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge.
            //
            // If the Flutter Android app targets Android SDK 16 (API 36) or later, then the Android
            // system will ignore this value.
            //
            // Should not show overlays, tap to reveal overlays, needs onChange callback
            // When the overlays come in on tap, the app does not receive the gesture and does not know
            // the system overlay has changed. The overlays cannot be dismissed, so adding the callback
            // support will allow users to restore the system ui and dismiss the overlays.
            // Not compatible with top/bottom overlays enabled.
            enabledOverlays =
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN;
        } else if (systemUiMode == SystemUiMode.IMMERSIVE) {
            // IMMERSIVE
            // Available starting at Android SDK 4.4 (API 19).
            //
            // If the Flutter Android app targets Android SDK 15 (API 35), then the Android
            // system will ignore this value unless the app also follows the opt out
            // instructions found in
            // https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge.
            //
            // If the Flutter Android app targets Android SDK 16 (API 36) or later, then the Android
            // system will ignore this value.
            //
            // Should not show overlays, swipe from edges to reveal overlays, needs onChange callback
            // When the overlays come in on swipe, the app does not receive the gesture and does not know
            // the system overlay has changed. The overlays cannot be dismissed, so adding callback
            // support will allow users to restore the system ui and dismiss the overlays.
            // Not compatible with top/bottom overlays enabled.
            enabledOverlays =
                    View.SYSTEM_UI_FLAG_IMMERSIVE
                            | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN;
        } else if (systemUiMode == SystemUiMode.IMMERSIVE_STICKY) {
            // STICKY IMMERSIVE
            // Available starting at Android SDK 4.4 (API 19).
            //
            // If the Flutter Android app targets Android SDK 15 (API 35), then the Android
            // system will ignore this value unless the app also follows the opt out
            // instructions found in
            // https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge.
            //
            // If the Flutter Android app targets Android SDK 16 (API 36) or later, then the Android
            // system will ignore this value.
            //
            // Should not show overlays, swipe from edges to reveal overlays. The app will also receive
            // the swipe gesture. The overlays cannot be dismissed, so adding callback support will
            // allow users to restore the system ui and dismiss the overlays.
            // Not compatible with top/bottom overlays enabled.
            enabledOverlays =
                    View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                            | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN;
        } else if (systemUiMode == SystemUiMode.EDGE_TO_EDGE
                && Build.VERSION.SDK_INT >= API_LEVELS.API_29) {
            // EDGE TO EDGE
            //
            // Available starting at Android SDK 10 (API 29).
            //
            // If the Flutter app targets Android SDK 15 (API 35) or later (Flutter does this by default),
            // then this mode is used by default.
            //
            // SDK 29 and up will apply a translucent body scrim behind 2/3 button navigation bars
            // to ensure contrast with buttons on the nav and status bars, unless the contrast is not
            // enforced in the overlay styling.
            isEdgeToEdge = true;
            enableEdgeToEdge(activity);
            if (currentTheme != null) {
                setSystemChromeSystemUIOverlayStyle(activity, currentTheme);
            }
            return;
        } else {
            // When none of the conditions are matched, return without updating the system UI overlays.
            return;
        }

        mEnabledOverlays = enabledOverlays;
        updateSystemUiOverlays(activity);
    }


    public static void updateSystemUiOverlays(Activity activity) {
        if (isEdgeToEdge) {
            // In edge-to-edge mode, re-apply the modern API instead of using deprecated
            // setSystemUiVisibility(), which could interfere with WindowCompat on API < 30.
            enableEdgeToEdge(activity);
        } else {
            activity.getWindow().getDecorView().setSystemUiVisibility(mEnabledOverlays);
        }
        if (currentTheme != null) {
            setSystemChromeSystemUIOverlayStyle(activity, currentTheme);
        }
    }

    private static void enableEdgeToEdge(Activity activity) {
        activity.getWindow().getDecorView().setSystemUiVisibility(0);
        WindowCompat.setDecorFitsSystemWindows(activity.getWindow(), false);
    }

    private static void disableEdgeToEdge(Activity activity) {
        if (isEdgeToEdge) {
            isEdgeToEdge = false;
            WindowCompat.setDecorFitsSystemWindows(activity.getWindow(), true);
        }
    }

    private static void setSystemChromeSystemUIOverlayStyle(Activity activity, SystemChromeStyle systemChromeStyle) {
        Window window = activity.getWindow();
        View view = window.getDecorView();
        WindowInsetsControllerCompat windowInsetsControllerCompat =
                new WindowInsetsControllerCompat(window, view);

        if (Build.VERSION.SDK_INT < API_LEVELS.API_30) {
            // Flag set to specify that this window is responsible for drawing the background for the
            // system bars. Must be set for all operations on API < 30 (Android SDK < 11) excluding
            // enforcing
            // system bar contrasts. Deprecated in API 30.
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);

            // Flag set to dismiss any requests for translucent system bars to be provided in lieu of what
            // is specified by systemChromeStyle. Must be set for all operations on API < 30 operations
            // excluding enforcing system bar contrasts. Deprecated in API 30.
            window.clearFlags(
                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
                            | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        }

        // SYSTEM STATUS BAR -------------------------------------------------------------------
        // You can't change the color of the system status bar until SDK 21, and you can't change the
        // color of the status icons until SDK 23. We only allow both starting at 23 to ensure buttons
        // and icons can be visible when changing the background color.
        // If transparent, SDK 29 and higher may apply a translucent scrim behind the bar to ensure
        // proper contrast. This can be overridden with
        // SystemChromeStyle.systemStatusBarContrastEnforced.
        if (systemChromeStyle.statusBarIconBrightness != null) {
            switch (systemChromeStyle.statusBarIconBrightness) {
                case DARK:
                    // Dark status bar icon brightness.
                    // Light status bar appearance.
                    windowInsetsControllerCompat.setAppearanceLightStatusBars(true);
                    break;
                case LIGHT:
                    // Light status bar icon brightness.
                    // Dark status bar appearance.
                    windowInsetsControllerCompat.setAppearanceLightStatusBars(false);
                    break;
            }
        }

        if (systemChromeStyle.statusBarColor != null) {
            // setStatusBarColor has no effect on Android 15 and above, meaning calls to this method will
            // have no effect on those versions.
            // Consider using the
            // [WindowInsetsController](https://developer.android.com/reference/android/view/WindowInsetsController)
            // or other Android 15+ APIs for system UI styling.
            if (Build.VERSION.SDK_INT < API_LEVELS.API_35) {
                window.setStatusBarColor(systemChromeStyle.statusBarColor);
            }
        }
        // You can't override the enforced contrast for a transparent status bar until SDK 29.
        // This overrides the translucent scrim that may be placed behind the bar on SDK 29+ to ensure
        // contrast is appropriate when using full screen layout modes like Edge to Edge.
        if (systemChromeStyle.systemStatusBarContrastEnforced != null
                && Build.VERSION.SDK_INT >= API_LEVELS.API_29) {
            window.setStatusBarContrastEnforced(systemChromeStyle.systemStatusBarContrastEnforced);
        }

        // SYSTEM NAVIGATION BAR --------------------------------------------------------------
        // You can't change the color of the system navigation bar until SDK 21, and you can't change
        // the color of the navigation buttons until SDK 26. We only allow both starting at 26 to
        // ensure buttons can be visible when changing the background color.
        // If transparent, SDK 29 and higher may apply a translucent scrim behind 2/3 button navigation
        // bars to ensure proper contrast. This can be overridden with
        // SystemChromeStyle.systemNavigationBarContrastEnforced.
        if (Build.VERSION.SDK_INT >= API_LEVELS.API_26) {
            if (systemChromeStyle.systemNavigationBarIconBrightness != null) {
                switch (systemChromeStyle.systemNavigationBarIconBrightness) {
                    case DARK:
                        // Dark navigation bar icon brightness.
                        // Light navigation bar appearance.
                        windowInsetsControllerCompat.setAppearanceLightNavigationBars(true);
                        break;
                    case LIGHT:
                        // Light navigation bar icon brightness.
                        // Dark navigation bar appearance.
                        windowInsetsControllerCompat.setAppearanceLightNavigationBars(false);
                        break;
                }
            }

            if (systemChromeStyle.systemNavigationBarColor != null) {
                // setNavigationBarColor has no effect on Android 15 and above, meaning calls to this method
                // will have no effect on those versions.
                // Consider using the
                // [WindowInsetsController](https://developer.android.com/reference/android/view/WindowInsetsController)
                // or other Android 15+ APIs for system UI styling.
                if (Build.VERSION.SDK_INT < API_LEVELS.API_35) {
                    window.setNavigationBarColor(systemChromeStyle.systemNavigationBarColor);
                }
            }
        }
        // You can't change the color of the navigation bar divider color until SDK 28.

        // setNavigationBarDividerColor has no effect on Android 15 and above, meaning calls to this
        // method will have no effect on those versions.
        // Consider using the
        // [WindowInsetsController](https://developer.android.com/reference/android/view/WindowInsetsController)
        // or other Android 15+ APIs for system UI styling.
        if (systemChromeStyle.systemNavigationBarDividerColor != null
                && Build.VERSION.SDK_INT >= API_LEVELS.API_28
                && Build.VERSION.SDK_INT < API_LEVELS.API_35) {
            window.setNavigationBarDividerColor(systemChromeStyle.systemNavigationBarDividerColor);
        }

        // You can't override the enforced contrast for a transparent navigation bar until SDK 29.
        // This overrides the translucent scrim that may be placed behind 2/3 button navigation bars on
        // SDK 29+ to ensure contrast is appropriate when using full screen layout modes like
        // Edge to Edge.
        if (systemChromeStyle.systemNavigationBarContrastEnforced != null
                && Build.VERSION.SDK_INT >= API_LEVELS.API_29) {
            window.setNavigationBarContrastEnforced(
                    systemChromeStyle.systemNavigationBarContrastEnforced);
        }

        currentTheme = systemChromeStyle;
    }


    public static class SystemChromeStyle {
        // TODO(mattcarroll): add color annotation
        @Nullable
        public final Integer statusBarColor;
        @Nullable
        public final Brightness statusBarIconBrightness;
        @Nullable
        public final Boolean systemStatusBarContrastEnforced;
        // TODO(mattcarroll): add color annotation
        @Nullable
        public final Integer systemNavigationBarColor;
        @Nullable
        public final Brightness systemNavigationBarIconBrightness;
        // TODO(mattcarroll): add color annotation
        @Nullable
        public final Integer systemNavigationBarDividerColor;
        @Nullable
        public final Boolean systemNavigationBarContrastEnforced;

        public SystemChromeStyle(
                @Nullable Integer statusBarColor,
                @Nullable Brightness statusBarIconBrightness,
                @Nullable Boolean systemStatusBarContrastEnforced,
                @Nullable Integer systemNavigationBarColor,
                @Nullable Brightness systemNavigationBarIconBrightness,
                @Nullable Integer systemNavigationBarDividerColor,
                @Nullable Boolean systemNavigationBarContrastEnforced) {
            this.statusBarColor = statusBarColor;
            this.statusBarIconBrightness = statusBarIconBrightness;
            this.systemStatusBarContrastEnforced = systemStatusBarContrastEnforced;
            this.systemNavigationBarColor = systemNavigationBarColor;
            this.systemNavigationBarIconBrightness = systemNavigationBarIconBrightness;
            this.systemNavigationBarDividerColor = systemNavigationBarDividerColor;
            this.systemNavigationBarContrastEnforced = systemNavigationBarContrastEnforced;
        }
    }

    public enum Brightness {
        LIGHT("Brightness.light"),
        DARK("Brightness.dark");

        @NonNull
        static Brightness fromValue(@NonNull String encodedName) throws NoSuchFieldException {
            for (Brightness brightness : Brightness.values()) {
                if (brightness.encodedName.equals(encodedName)) {
                    return brightness;
                }
            }
            throw new NoSuchFieldException("No such Brightness: " + encodedName);
        }

        @NonNull
        private String encodedName;

        Brightness(@NonNull String encodedName) {
            this.encodedName = encodedName;
        }
    }

    public static class API_LEVELS {
        @VisibleForTesting
        public static final int FLUTTER_MIN = 24;
        /**
         * Android 5.0 (Lollipop)
         */
        public static final int API_21 = 21;
        /**
         * Android 5.1 (Lollipop MR1)
         */
        public static final int API_22 = 22;
        /**
         * Android 6.0 (Marshmallow)
         */
        public static final int API_23 = 23;
        /**
         * Android 7.0 (Nougat)
         */
        public static final int API_24 = 24;
        /**
         * Android 7.1 (Nougat MR1)
         */
        public static final int API_25 = 25;
        /**
         * Android 8.0 (Oreo)
         */
        public static final int API_26 = 26;
        /**
         * Android 8.1 (Oreo MR1)
         */
        public static final int API_27 = 27;
        /**
         * Android 9 (Pie)
         */
        public static final int API_28 = 28;
        /**
         * Android 10 (Q)
         */
        public static final int API_29 = 29;
        /**
         * Android 11 (R)
         */
        public static final int API_30 = 30;
        /**
         * Android 12 (S)
         */
        public static final int API_31 = 31;
        /**
         * Android 12L (Sv2)
         */
        public static final int API_32 = 32;
        /**
         * Android 13 (Tiramisu)
         */
        public static final int API_33 = 33;
        /**
         * Android 14 (Upside Down Cake)
         */
        public static final int API_34 = 34;
        /**
         * Android 15 (Vanilla Ice Cream)
         */
        public static final int API_35 = 35;
        /**
         * Android 16
         */
        public static final int API_36 = 36;
    }
}
