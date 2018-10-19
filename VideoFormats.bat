REM   Template for various video formats
REM   check the official encoding wiki: https://trac.ffmpeg.org/wiki


REM   for %%i in ("*.mp4") do echo %%~ni >> echo filename only

REM   Constant bitrate : -crf 0-51  lower is better (  subjectively sane range is 17–28. Consider 17 or 18 to be visually lossless or nearly)
REM   Variable bitrate: -b:v 3M   means 3MBit/s
REM   Set audio bitrate with -b:a 96k

REM   batch variables 
REM   SET myvar=4
REM   SET /A myvar=2+2

SET crfv=23
SET bv=4000k
SET bvm=5000k
SET buf=3500k
SET ba=128k
SET thrds=2
SET loglev=info


for %%i in ("*.webm") do ( 


REM  -WEBM V9-
REM constrained quality : Keep bitrate below b:v and set variations with crf
REM ffmpeg -loglevel info -y -i "%%i" -c:v libvpx-vp9 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 1 -threads %thrds% -speed 4 -c:a libopus -b:a %ba% -movflags +faststart -f webm NUL && ^
REM ffmpeg -loglevel info -n -i "%%i" -c:v libvpx-vp9 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 2 -threads %thrds% -speed 1 -c:a libopus -b:a %ba% -movflags +faststart -f webm "%%~ni-2passV9.webm"


REM ffmpeg -loglevel %loglev% -y -i "%%i" -c:v libvpx-vp9 -b:v %bv% -maxrate %bvm% -bufsize %buf% -threads %thrds% -c:a libopus -b:a %ba% -movflags +faststart -f webm "%%~ni-V9.webm"

REM   -WEBM V8-  
REM 1 pass. control quality with -crf: lower=better or -b:v sets video bitrate, here  3MBit/s
REM ffmpeg -i "%%i" -c:v libvpx -b:v %bv% -c:a libvorbis -b:a %ba% "%%~niV8.webm"

REM   -H265-
REM   2 pass encoding. set quality with average bitrate  -b:v 3M  <> 3MBit/s   
REM ffmpeg -y -i "%%i" -c:v libx265 -b:v %bv% -x265-params pass=1 -c:a aac -b:a %ba% -f mp4 NUL && ^
REM ffmpeg -n -i "%%i" -c:v libx265 -b:v %bv% -x265-params pass=2 -c:a aac -b:a %ba% "%%~ni2passH265.mp4"



REM   -H264-

REM constrained quality: set average bitrate with b:v , maximum bitrate with maxrate

ffmpeg -loglevel info -n -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -c:a aac -b:a %ba% -threads %thrds% -profile:v high -level 4.0 -preset slower -vf format=yuv420p -f mp4 "%%~ni-H264.mp4"

REM ffmpeg -hide_banner -y -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 1 -speed 4 -threads %thrds% -c:a -b:a %ba% -profile:v high -level 4.0 -preset slower -vf format=yuv420p -movflags +faststart -f mp4 NUL && ^
REM ffmpeg -hide_banner -n -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 2 -speed 1 -threads %thrds% -c:a -b:a %ba% -profile:v high -level 4.0 -preset slower -vf format=yuv420p -movflags +faststart -f mp4 "%%~ni-2passH264.mp4"

REM compatibility with baseline and level 3.0
REM ffmpeg -loglevel info -n -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -c:a aac -b:a %ba% -threads %thrds% -profile:v baseline -level 3.0 -preset slower -vf format=yuv420p -f mp4 "%%~ni-comp-H264.mp4"

REM ffmpeg -hide_banner -y -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 1 -speed 4 -threads %thrds% -c:a aac -b:a %ba% -profile:v baseline -level 3.0 -preset slower -vf format=yuv420p -movflags +faststart -f mp4 NUL && ^
REM ffmpeg -hide_banner -n -i "%%i" -c:v libx264 -b:v %bv% -maxrate %bvm% -bufsize %buf% -pass 2 -speed 1 -threads %thrds% -c:a aac -b:a %ba% -profile:v baseline -level 3.0 -preset slower -vf format=yuv420p -movflags +faststart -f mp4 "%%~ni-comp-2passH264.mp4"



)

pause
