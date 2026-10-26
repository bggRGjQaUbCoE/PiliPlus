package com.example.piliplus

internal data class Media3ControlBounds(val left: Int, val top: Int, val right: Int, val bottom: Int) {
    val width get() = right - left
    val height get() = bottom - top

    fun intersects(other: Media3ControlBounds) =
        left < other.right && right > other.left && top < other.bottom && bottom > other.top

    fun contains(other: Media3ControlBounds) =
        left <= other.left && top <= other.top && right >= other.right && bottom >= other.bottom

    fun expanded(gap: Int) = Media3ControlBounds(left - gap, top - gap, right + gap, bottom + gap)
}

internal fun media3CutoutPosition(
    button: Media3ControlBounds,
    window: Media3ControlBounds,
    cutouts: List<Media3ControlBounds>,
    occupied: List<Media3ControlBounds>,
    gap: Int,
): Media3ControlBounds? {
    if (cutouts.none { it.intersects(button) }) return button

    val obstacles = (cutouts + occupied).map { it.expanded(gap) }
    val xs = listOf(button.left, window.left, window.right - button.width) +
        obstacles.flatMap { listOf(it.left - button.width, it.right) }
    val ys = listOf(button.top, window.top, window.bottom - button.height) +
        obstacles.flatMap { listOf(it.top - button.height, it.bottom) }
    var nearest: Media3ControlBounds? = null
    var distance = Long.MAX_VALUE
    for (x in xs.distinct()) {
        for (y in ys.distinct()) {
            val candidate = Media3ControlBounds(x, y, x + button.width, y + button.height)
            if (!window.contains(candidate) || obstacles.any { it.intersects(candidate) }) continue
            val dx = (x - button.left).toLong()
            val dy = (y - button.top).toLong()
            val squaredDistance = dx * dx + dy * dy
            if (squaredDistance < distance) {
                nearest = candidate
                distance = squaredDistance
            }
        }
    }
    return nearest
}
