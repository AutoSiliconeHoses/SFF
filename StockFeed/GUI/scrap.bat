Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"

IF "%cd%"=="Z:\Stock File Fetcher\StockFeed\GUI\Output" (
  del *.txt
  ECHO "Scrapped Successfully"
)

IF NOT "%cd%"=="Z:\Stock File Fetcher\StockFeed\GUI\Output" (
  ECHO "Directory not correct, please check your drives."
  PAUSE
)
