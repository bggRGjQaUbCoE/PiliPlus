package com.example.piliplus

import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Test
import java.io.RandomAccessFile
import java.nio.file.Files

class AnimatedWebpMuxerTest {
    @Test
    fun writesAnimatedWebpContainerAndFrameDurations() {
        val path = Files.createTempFile("pili-animated-webp", ".webp")
        try {
            RandomAccessFile(path.toFile(), "rw").use { file ->
                AnimatedWebpMuxer.initialize(file, width = 320, height = 180)
                AnimatedWebpMuxer.writeFrame(file, 320, 180, 83, imageChunk(4))
                AnimatedWebpMuxer.writeFrame(file, 320, 180, 125, imageChunk(3))
                AnimatedWebpMuxer.finalize(file)
            }

            val bytes = Files.readAllBytes(path)
            assertEquals("RIFF", bytes.fourCc(0))
            assertEquals(bytes.size - 8L, bytes.uint32Le(4))
            assertEquals("WEBP", bytes.fourCc(8))
            assertEquals("VP8X", bytes.fourCc(12))
            assertEquals(0x02, bytes[20].toInt())
            assertEquals(319, bytes.uint24Le(24))
            assertEquals(179, bytes.uint24Le(27))
            assertEquals("ANIM", bytes.fourCc(30))

            val frames = findChunks(bytes, "ANMF")
            assertEquals(2, frames.size)
            assertEquals(83, bytes.uint24Le(frames[0] + 20))
            assertEquals(125, bytes.uint24Le(frames[1] + 20))
            assertArrayEquals(byteArrayOf('V'.code.toByte(), 'P'.code.toByte(), '8'.code.toByte(), ' '.code.toByte()), bytes.copyOfRange(frames[0] + 24, frames[0] + 28))
            assertEquals(0, bytes.last().toInt())
        } finally {
            Files.deleteIfExists(path)
        }
    }

    private fun imageChunk(payloadSize: Int): ByteArray = ByteArray(8 + payloadSize + (payloadSize and 1)).apply {
        "VP8 ".toByteArray(Charsets.US_ASCII).copyInto(this)
        writeUInt32Le(4, payloadSize)
        repeat(payloadSize) { this[8 + it] = (it + 1).toByte() }
    }

    private fun findChunks(bytes: ByteArray, type: String): List<Int> {
        val offsets = mutableListOf<Int>()
        var offset = 12
        while (offset + 8 <= bytes.size) {
            val size = bytes.uint32Le(offset + 4).toInt()
            if (bytes.fourCc(offset) == type) offsets += offset
            offset += 8 + size + (size and 1)
        }
        return offsets
    }
}

private fun ByteArray.fourCc(offset: Int): String = String(this, offset, 4, Charsets.US_ASCII)

private fun ByteArray.uint32Le(offset: Int): Long =
    (0 until 4).fold(0L) { value, shift -> value or ((this[offset + shift].toLong() and 0xFF) shl (shift * 8)) }

private fun ByteArray.uint24Le(offset: Int): Int =
    (0 until 3).fold(0) { value, shift -> value or ((this[offset + shift].toInt() and 0xFF) shl (shift * 8)) }

private fun ByteArray.writeUInt32Le(offset: Int, value: Int) {
    repeat(4) { shift -> this[offset + shift] = (value shr (shift * 8)).toByte() }
}
