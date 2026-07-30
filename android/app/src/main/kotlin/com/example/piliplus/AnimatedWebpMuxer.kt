package com.example.piliplus

import java.io.RandomAccessFile

internal object AnimatedWebpMuxer {
    fun initialize(file: RandomAccessFile, width: Int, height: Int) {
        require(width in 1..MAX_WEBP_DIMENSION && height in 1..MAX_WEBP_DIMENSION)
        file.writeFourCc("RIFF")
        file.writeUInt32Le(0)
        file.writeFourCc("WEBP")
        file.writeChunk("VP8X", ByteArray(10).apply {
            this[0] = 0x02
            writeUInt24Le(4, width - 1)
            writeUInt24Le(7, height - 1)
        })
        file.writeChunk("ANIM", ByteArray(6))
    }

    fun writeFrame(
        file: RandomAccessFile,
        width: Int,
        height: Int,
        durationMs: Int,
        imageChunks: ByteArray,
    ) {
        require(width in 1..MAX_WEBP_DIMENSION && height in 1..MAX_WEBP_DIMENSION)
        require(imageChunks.isNotEmpty())
        val header = ByteArray(16).apply {
            writeUInt24Le(6, width - 1)
            writeUInt24Le(9, height - 1)
            writeUInt24Le(12, durationMs.coerceIn(1, 0xFFFFFF))
            this[15] = 0x02
        }
        file.writeFourCc("ANMF")
        file.writeUInt32Le((header.size + imageChunks.size).toLong())
        file.write(header)
        file.write(imageChunks)
        if ((header.size + imageChunks.size) and 1 != 0) file.write(0)
    }

    fun finalize(file: RandomAccessFile) {
        val length = file.length()
        require(length >= 12 && length <= UInt.MAX_VALUE.toLong()) {
            "Animated WebP output size is invalid"
        }
        file.seek(4)
        file.writeUInt32Le(length - 8)
    }
}

internal const val MAX_WEBP_DIMENSION = 0x1000000

private fun RandomAccessFile.writeChunk(type: String, payload: ByteArray) {
    writeFourCc(type)
    writeUInt32Le(payload.size.toLong())
    write(payload)
    if (payload.size and 1 != 0) write(0)
}

private fun RandomAccessFile.writeFourCc(value: String) {
    require(value.length == 4)
    write(value.toByteArray(Charsets.US_ASCII))
}

private fun RandomAccessFile.writeUInt32Le(value: Long) {
    repeat(4) { shift -> write((value shr (shift * 8)).toInt() and 0xFF) }
}

private fun ByteArray.writeUInt24Le(offset: Int, value: Int) {
    repeat(3) { shift -> this[offset + shift] = (value shr (shift * 8)).toByte() }
}
