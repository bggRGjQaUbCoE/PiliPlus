package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class Media3SuperResolutionTest {
    @Test
    fun disablesTheEffectWithoutChangingTheVideo() {
        assertNull(
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.DISABLE,
                1280,
                720,
            ),
        )
    }

    @Test
    fun efficiencyUpscalesLandscapeAndPortraitTo1080p() {
        assertEquals(
            Media3SuperResolutionTarget(1920, 1080),
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.EFFICIENCY,
                1280,
                720,
            ),
        )
        assertEquals(
            Media3SuperResolutionTarget(1080, 1920),
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.EFFICIENCY,
                720,
                1280,
            ),
        )
    }

    @Test
    fun qualityUsesTwoTimesScalingButNeverExceeds4k() {
        assertEquals(
            Media3SuperResolutionTarget(2560, 1440),
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.QUALITY,
                1280,
                720,
            ),
        )
        assertEquals(
            Media3SuperResolutionTarget(3840, 2160),
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.QUALITY,
                2560,
                1440,
            ),
        )
    }

    @Test
    fun neverDownscalesAnAlreadyLargeSource() {
        assertNull(
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.EFFICIENCY,
                3840,
                2160,
            ),
        )
        assertNull(
            resolveMedia3SuperResolutionTarget(
                Media3SuperResolutionMode.QUALITY,
                3840,
                2160,
            ),
        )
    }
}
