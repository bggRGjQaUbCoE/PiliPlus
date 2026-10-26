package com.example.piliplus

import android.os.Build
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.Space
import kotlin.math.roundToInt

internal class Media3CutoutAvoidance(
    private val root: ViewGroup,
    buttons: List<Pair<View, FrameLayout>>,
    private val fixedControls: List<View>,
) {
    private class Target(val button: View, val container: FrameLayout) {
        val parent = button.parent as ViewGroup
        val params = button.layoutParams
        var spacer: Space? = null
        val anchor: View get() = spacer ?: button

        fun place(bounds: Media3ControlBounds, original: Media3ControlBounds) {
            if (bounds == original) {
                spacer?.let {
                    container.removeView(button)
                    val index = parent.indexOfChild(it)
                    parent.removeView(it)
                    button.translationX = 0f
                    button.translationY = 0f
                    parent.addView(button, index, params)
                    spacer = null
                }
                return
            }
            if (spacer == null) {
                // A full-window parent keeps the moved button both visible and touchable.
                // The spacer preserves every sibling's original layout position.
                val placeholder = Space(button.context).apply {
                    minimumWidth = button.measuredWidth
                    minimumHeight = button.measuredHeight
                }
                val index = parent.indexOfChild(button)
                parent.removeView(button)
                parent.addView(placeholder, index, params)
                spacer = placeholder
                container.addView(
                    button,
                    FrameLayout.LayoutParams(params.width, params.height, Gravity.TOP or Gravity.LEFT),
                )
            }
            val location = IntArray(2)
            container.getLocationInWindow(location)
            button.translationX = (bounds.left - location[0]).toFloat()
            button.translationY = (bounds.top - location[1]).toFloat()
        }

        fun syncAnchor() {
            spacer?.let {
                val visibility = if (button.visibility == View.GONE) View.GONE else View.INVISIBLE
                if (it.visibility != visibility) it.visibility = visibility
                if (it.minimumWidth != button.measuredWidth) it.minimumWidth = button.measuredWidth
                if (it.minimumHeight != button.measuredHeight) it.minimumHeight = button.measuredHeight
            }
        }
    }

    private val targets = buttons.map { (button, container) -> Target(button, container) }
    private var cutouts = emptyList<Media3ControlBounds>()
    private val gap = (4 * root.resources.displayMetrics.density).roundToInt()

    init {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            root.setOnApplyWindowInsetsListener { _, insets ->
                cutouts = insets.displayCutout?.boundingRects.orEmpty().map {
                    Media3ControlBounds(it.left, it.top, it.right, it.bottom)
                }
                update()
                insets
            }
            root.viewTreeObserver.addOnGlobalLayoutListener { update() }
            root.requestApplyInsets()
        }
    }

    private fun View.boundsInWindow(): Media3ControlBounds {
        val location = IntArray(2)
        getLocationInWindow(location)
        return Media3ControlBounds(location[0], location[1], location[0] + width, location[1] + height)
    }

    private fun update() {
        if (root.width == 0 || root.height == 0) return
        targets.forEach { it.syncAnchor() }
        val window = root.boundsInWindow()
        val visibleTargets = targets.filter { it.button.isShown && it.button.width > 0 && it.button.height > 0 }
        val positions = visibleTargets.associateWith { it.anchor.boundsInWindow() }.toMutableMap()
        val fixed = fixedControls.filter { it.isShown }.map { it.boundsInWindow() }
        for (target in visibleTargets) {
            val original = positions.getValue(target)
            val occupied = fixed + positions.filterKeys { it != target }.values
            val position = media3CutoutPosition(original, window, cutouts, occupied, gap)
            if (position == null) {
                Log.w("PiliPlusMedia3", "No unobscured position for control ${target.button.id}")
                target.place(original, original)
                continue
            }
            target.place(position, original)
            positions[target] = position
        }
    }
}
