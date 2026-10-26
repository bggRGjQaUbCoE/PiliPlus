package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class Media3CutoutPositionTest {
    private val landscape = Media3ControlBounds(0, 0, 1000, 500)
    private val portrait = Media3ControlBounds(0, 0, 500, 1000)

    private fun position(
        button: Media3ControlBounds,
        cutouts: List<Media3ControlBounds>,
        window: Media3ControlBounds = landscape,
        occupied: List<Media3ControlBounds> = emptyList(),
    ) = media3CutoutPosition(button, window, cutouts, occupied, 4)

    @Test
    fun landscapeCameraMovesOnlyTheOverlappingLockButton() {
        val camera = Media3ControlBounds(0, 225, 40, 275)
        val lock = Media3ControlBounds(16, 226, 64, 274)
        assertEquals(Media3ControlBounds(44, 226, 92, 274), position(lock, listOf(camera)))
        for (button in listOf(
            Media3ControlBounds(8, 8, 56, 56),
            Media3ControlBounds(10, 440, 58, 488),
            Media3ControlBounds(936, 226, 984, 274),
        )) {
            assertEquals(button, position(button, listOf(camera)))
        }
    }

    @Test
    fun cameraOnEitherHorizontalEdgeIsAvoided() {
        val button = Media3ControlBounds(936, 226, 984, 274)
        val camera = Media3ControlBounds(960, 225, 1000, 275)
        assertEquals(Media3ControlBounds(908, 226, 956, 274), position(button, listOf(camera)))
    }

    @Test
    fun portraitCameraOnEitherVerticalEdgeIsAvoided() {
        val top = Media3ControlBounds(226, 8, 274, 56)
        val bottom = Media3ControlBounds(226, 944, 274, 992)
        assertEquals(
            Media3ControlBounds(226, 44, 274, 92),
            position(top, listOf(Media3ControlBounds(225, 0, 275, 40)), portrait),
        )
        assertEquals(
            Media3ControlBounds(226, 908, 274, 956),
            position(bottom, listOf(Media3ControlBounds(225, 960, 275, 1000)), portrait),
        )
    }

    @Test
    fun insetPunchHoleUsesActualBoundsNotTheWholeEdge() {
        val camera = Media3ControlBounds(20, 12, 40, 32)
        val back = Media3ControlBounds(8, 8, 56, 56)
        val moved = requireNotNull(position(back, listOf(camera), portrait))
        assertFalse(moved.intersects(camera.expanded(4)))
        assertTrue(portrait.contains(moved))
        val info = Media3ControlBounds(400, 8, 492, 56)
        assertEquals(info, position(info, listOf(camera), portrait))
    }

    @Test
    fun movedButtonDoesNotCoverNeighboringControls() {
        val back = Media3ControlBounds(8, 8, 56, 56)
        val title = Media3ControlBounds(56, 8, 400, 56)
        val camera = Media3ControlBounds(0, 0, 40, 60)
        assertEquals(
            Media3ControlBounds(8, 64, 56, 112),
            position(back, listOf(camera), portrait, listOf(title)),
        )
    }

    @Test
    fun rotationAndCutoutRemovalUseOriginalLayoutBounds() {
        val button = Media3ControlBounds(16, 226, 64, 274)
        val leftCamera = listOf(Media3ControlBounds(0, 225, 40, 275))
        val moved = position(button, leftCamera)
        repeat(3) { assertEquals(moved, position(button, leftCamera)) }
        assertEquals(button, position(button, listOf(Media3ControlBounds(960, 225, 1000, 275))))
        assertEquals(button, position(button, emptyList()))
    }

    @Test
    fun multipleCutoutsAndNonzeroWindowOriginAreSupported() {
        val window = Media3ControlBounds(100, 200, 600, 1200)
        val button = Media3ControlBounds(108, 208, 156, 256)
        val cutouts = listOf(
            Media3ControlBounds(100, 200, 140, 260),
            Media3ControlBounds(144, 200, 180, 260),
        )
        val moved = requireNotNull(position(button, cutouts, window))
        assertTrue(window.contains(moved))
        assertTrue(cutouts.none { it.expanded(4).intersects(moved) })
        assertEquals(button.width, moved.width)
        assertEquals(button.height, moved.height)
    }

    @Test
    fun touchingButNotOverlappingCameraDoesNotMoveButton() {
        val button = Media3ControlBounds(40, 226, 88, 274)
        assertEquals(button, position(button, listOf(Media3ControlBounds(0, 225, 40, 275))))
    }

    @Test
    fun nearbyButtonsCanBothMoveWithoutColliding() {
        val back = Media3ControlBounds(8, 8, 56, 56)
        val info = Media3ControlBounds(60, 8, 108, 56)
        val camera = listOf(Media3ControlBounds(0, 0, 100, 40))
        val movedBack = requireNotNull(position(back, camera, portrait, listOf(info)))
        val movedInfo = requireNotNull(position(info, camera, portrait, listOf(movedBack)))
        assertFalse(movedBack.intersects(movedInfo.expanded(4)))
        for (button in listOf(movedBack, movedInfo)) {
            assertTrue(portrait.contains(button))
            assertTrue(camera.none { it.expanded(4).intersects(button) })
        }
    }

    @Test
    fun reportsWhenThereIsNoRoomForAnUnobscuredButton() {
        assertNull(position(Media3ControlBounds(8, 8, 56, 56), listOf(landscape)))
    }
}
