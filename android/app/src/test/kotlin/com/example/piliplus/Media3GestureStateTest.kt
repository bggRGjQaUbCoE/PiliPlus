package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class Media3GestureStateTest {
    private fun gestures(quickDoubleTap: Boolean = true, speed: Float = 3f) =
        Media3GestureState(quickDoubleTap, 15000, speed)

    @Test
    fun doubleTapUsesTheSameOuterQuartersAsMpv() {
        val state = gestures()
        assertEquals(-1, state.doubleTapDirection(249f, 1000))
        for (x in listOf(250f, 500f, 750f)) {
            assertEquals(0, state.doubleTapDirection(x, 1000))
        }
        assertEquals(1, state.doubleTapDirection(751f, 1000))
        for (x in listOf(0f, 500f, 1000f)) {
            assertEquals(0, gestures(quickDoubleTap = false).doubleTapDirection(x, 1000))
        }
    }

    @Test
    fun seekingUsesConfiguredStepAndClampsToMediaBounds() {
        val state = gestures()
        assertEquals(35000L, state.seekPosition(50000, 100000, -1))
        assertEquals(65000L, state.seekPosition(50000, 100000, 1))
        assertEquals(0L, state.seekPosition(5000, 100000, -1))
        assertEquals(100000L, state.seekPosition(95000, 100000, 1))
        assertNull(state.seekPosition(0, -1, 1))
        assertNull(state.seekPosition(0, 0, 1))
        val largeStep = Media3GestureState(true, Long.MAX_VALUE, 3f)
        assertEquals(100000L, largeStep.seekPosition(50000, 100000, 1))
    }

    @Test
    fun lockDisablesDoubleTapSeekingAndBoost() {
        val state = gestures().apply { locked = true }
        assertNull(state.doubleTapDirection(10f, 1000))
        assertNull(state.seekPosition(50000, 100000, 1))
        assertNull(state.startSpeedBoost(1f, true))
        state.locked = false
        assertEquals(-1, state.doubleTapDirection(10f, 1000))
    }

    @Test
    fun releaseOrLifecycleStopRestoresSpeedExactlyOnce() {
        val state = gestures()
        assertNull(state.startSpeedBoost(1.25f, false))
        assertEquals(3f, state.startSpeedBoost(1.25f, true))
        assertNull(state.startSpeedBoost(3f, true))
        assertEquals(1.25f, state.endSpeedBoost())
        assertNull(state.endSpeedBoost())
        assertEquals(3f, state.startSpeedBoost(2f, true))
        assertEquals(2f, state.endSpeedBoost())
    }

    @Test
    fun automaticBoostDoublesCurrentSpeedWithoutPersistingIt() {
        val state = gestures(speed = 0f)
        assertEquals(3f, state.startSpeedBoost(1.5f, true))
        assertEquals(1.5f, state.endSpeedBoost())
        assertEquals(4f, state.startSpeedBoost(2f, true))
        assertEquals(2f, state.endSpeedBoost())
    }
}
