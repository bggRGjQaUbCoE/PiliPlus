package com.example.piliplus

import java.io.File
import javax.xml.parsers.DocumentBuilderFactory
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.w3c.dom.Element

class Media3FullscreenLayoutTest {
    private val android = "http://schemas.android.com/apk/res/android"
    private val app = "http://schemas.android.com/apk/res-auto"

    private fun resource(path: String): Element =
        DocumentBuilderFactory.newInstance().apply {
            isNamespaceAware = true
        }.newDocumentBuilder().parse(File("src/main/res/$path")).documentElement

    private fun Element.elements(tag: String): List<Element> =
        getElementsByTagName(tag).let { nodes ->
            List(nodes.length) { nodes.item(it) as Element }
        }

    private fun assertFullWindow(view: Element) {
        assertEquals("match_parent", view.getAttributeNS(android, "layout_width"))
        assertEquals("match_parent", view.getAttributeNS(android, "layout_height"))
        assertNotEquals("true", view.getAttributeNS(android, "fitsSystemWindows"))
        for (attribute in listOf(
            "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
            "paddingStart", "paddingEnd", "paddingHorizontal", "paddingVertical",
            "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight",
            "layout_marginBottom", "layout_marginStart", "layout_marginEnd",
            "layout_marginHorizontal", "layout_marginVertical",
        )) {
            assertFalse("Full-window containers must not reserve $attribute", view.hasAttributeNS(android, attribute))
        }
    }

    @Test
    fun fullscreenControllerIsAccessedOnlyAfterInstallingWindowContent() {
        val activity = File(
            "src/main/kotlin/com/example/piliplus/Media3PlayerActivity.kt",
        ).readText()
        val onCreate = activity.substringAfter("override fun onCreate(")
            .substringBefore("override fun onWindowFocusChanged(")
        val installContent = onCreate.indexOf("setContentView(R.layout.media3_player)")
        val enterFullscreen = onCreate.indexOf("enterFullscreen()")
        assertTrue("The player content must be installed during onCreate", installContent >= 0)
        assertTrue(
            "PhoneWindow.getInsetsController() requires an installed decor view",
            enterFullscreen > installContent,
        )
    }

    @Test
    fun videoDoesNotReserveASystemOrCutoutSafeZone() {
        val root = resource("layout/media3_player.xml")
        assertFullWindow(root)
        val player = root.elements("androidx.media3.ui.PlayerView").single()
        assertEquals(root, player.parentNode)
        assertFullWindow(player)
        assertEquals("surface_view", player.getAttributeNS(app, "surface_type"))
        assertEquals("@layout/media3_controls", player.getAttributeNS(app, "controller_layout_id"))
    }

    @Test
    fun nativeFullscreenThemeAllowsShortEdgeCutoutsOnAndroid9And10() {
        val theme = resource("values/styles.xml").elements("style").single {
            it.getAttribute("name") == "Media3PlayerTheme"
        }
        val items = theme.elements("item").associate { it.getAttribute("name") to it.textContent }
        assertEquals("true", items["android:windowFullscreen"])
        assertEquals("shortEdges", items["android:windowLayoutInDisplayCutoutMode"])
    }

    @Test
    fun controlsAndLockUseTheSameFullWindowBoundsAsTheVideo() {
        val controls = resource("layout/media3_controls.xml")
        assertEquals("@+id/media3_controls", controls.getAttributeNS(android, "id"))
        assertFullWindow(controls)

        val root = resource("layout/media3_player.xml")
        val lockContainer = root.elements("FrameLayout").single {
            it.getAttributeNS(android, "id") == "@+id/media3_lock_container"
        }
        assertEquals(root, lockContainer.parentNode)
        assertFullWindow(lockContainer)
        assertEquals(
            "@+id/media3_lock",
            lockContainer.elements("ImageButton").single().getAttributeNS(android, "id"),
        )
        assertEquals(0, lockContainer.elements("androidx.media3.ui.PlayerView").size)
    }

    @Test
    fun cutoutAvoidanceDoesNotInsetWholeControlRows() {
        val controls = File("src/main/kotlin/com/example/piliplus/Media3Controls.kt").readText()
        val avoidance = File("src/main/kotlin/com/example/piliplus/Media3CutoutAvoidance.kt").readText()
        assertTrue(controls.contains("Media3CutoutAvoidance("))
        assertTrue(avoidance.contains("insets.displayCutout?.boundingRects"))
        assertFalse(
            "Control spacing belongs in the layout, not runtime safe-area padding",
            (controls + avoidance).contains("setPadding("),
        )
        assertFalse(avoidance.contains("systemBars()"))
    }
}
