import 'dart:convert';
import 'package:flutter/foundation.dart';

class SubtitleLine {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleLine({
    required this.start,
    required this.end,
    required this.text,
  });

  @override
  String toString() => 'SubtitleLine($start, $end, $text)';
}

class SubtitleParser {
  static List<SubtitleLine> parse(String content) {
    if (content.contains('WEBVTT')) {
      return _parseVTT(content);
    } else {
      return _parseSRT(content);
    }
  }

  static List<SubtitleLine> _parseVTT(String content) {
    // Basic VTT parser
    final lines = LineSplitter.split(content).toList();
    final List<SubtitleLine> subtitles = [];
    
    // Regex for timestamp: 00:00:00.000 or 00:00.000
    // VTT uses . for milliseconds
    final timeExp = RegExp(r'((\d{2}:)?\d{2}:\d{2}\.\d{3})');

    int index = 0;
    // Skip header
    while (index < lines.length && lines[index].trim() != '') {
      index++;
    }

    while (index < lines.length) {
      final line = lines[index].trim();
      if (line.isEmpty) {
        index++;
        continue;
      }

      // Check if it's an ID (digits) or timestamp line
      if (!line.contains('-->')) {
        // Skip ID line
        index++;
        if (index >= lines.length) break;
      }

      final timeLine = lines[index].trim();
      if (!timeLine.contains('-->')) {
         index++;
         continue;
      }

      final times = timeTimeline(timeLine);
      if (times == null) {
        index++;
        continue;
      }

      index++;
      final buffer = StringBuffer();
      while (index < lines.length && lines[index].trim().isNotEmpty) {
        buffer.writeln(lines[index].trim());
        index++;
      }
      
      subtitles.add(SubtitleLine(
        start: times.start,
        end: times.end,
        text: buffer.toString().trim(),
      ));
    }

    return subtitles;
  }
  
  static List<SubtitleLine> _parseSRT(String content) {
     // Basic SRT parser
    final lines = LineSplitter.split(content).toList();
    final List<SubtitleLine> subtitles = [];
    
    // Regex for timestamp: 00:00:00,000
    // SRT uses , for milliseconds

    int index = 0;
    while (index < lines.length) {
      final line = lines[index].trim();
      if (line.isEmpty) {
        index++;
        continue;
      }

      // Skip ID (assume digit)
       if (int.tryParse(line) != null) {
         index++;
         if(index >= lines.length) break;
       }
       
       final timeLine = lines[index].trim();
       if(!timeLine.contains('-->')){
           // Not a time line, maybe we misidentified ID or something else, skip
           index++;
           continue;
       }
       
       final times = timeTimeline(timeLine, isSrt: true);
       if(times == null) {
         index++;
         continue;
       }
       
       index++;
       final buffer = StringBuffer();
       while(index < lines.length && lines[index].trim().isNotEmpty) {
         buffer.writeln(lines[index].trim());
         index++;
       }
       
       subtitles.add(SubtitleLine(
         start: times.start,
         end: times.end,
         text: buffer.toString().trim(),
       ));
    }
    return subtitles;
  }

  static ({Duration start, Duration end})? timeTimeline(String line, {bool isSrt = false}) {
     final parts = line.split('-->');
     if (parts.length != 2) return null;
     
     final startStr = parts[0].trim();
     final endStr = parts[1].trim().split(' ').first; // remove extra styling
     
     final start = parseDuration(startStr, isSrt: isSrt);
     final end = parseDuration(endStr, isSrt: isSrt);
     
     if (start != null && end != null) {
       return (start: start, end: end);
     }
     return null;
  }

  static Duration? parseDuration(String s, {bool isSrt = false}) {
    // 00:00:20.000 (VTT) or 00:00:20,000 (SRT)
    // Handle optional hours
    final parts = s.split(isSrt ? ',' : '.');
    if (parts.length < 2) return null; // Must have milli
    
    final hms = parts[0].split(':');
    int h = 0, m = 0, sec = 0, ms = 0;
    
    if (int.tryParse(parts[1]) != null) {
      ms = int.parse(parts[1]);
    }
    
    if (hms.length == 3) {
      h = int.parse(hms[0]);
      m = int.parse(hms[1]);
      sec = int.parse(hms[2]);
    } else if (hms.length == 2) {
      m = int.parse(hms[0]);
      sec = int.parse(hms[1]);
    } else {
      return null;
    }
    
    return Duration(hours: h, minutes: m, seconds: sec, milliseconds: ms);
  }
}
