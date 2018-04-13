Z:
cd "Z:\Stock File Fetcher\Upload"

IF "%cd%"=="Z:\Stock File Fetcher\Upload" (
  copy *.txt amazon.txt
  ECHO "Compiled Successfully"
  mkdir "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "Z:\Stock File Fetcher\Upload\Amazon"
  del *txt
  cd "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "\\Diskstation\Feeds\Stock File Fetcher\Upload"
  cd "Z:\Stock File Fetcher\Upload"
  rmdir "Z:\Stock File Fetcher\Upload\Amazon"
  )
::This script combines all the upload files into one singular upload file to be submitted to Amazon

IF NOT "%cd%"=="Z:\Stock File Fetcher\Upload" (
  ECHO "Directory not correct, please check your drives."
  PAUSE
)
