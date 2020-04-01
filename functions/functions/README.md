gcloud init

gcloud functions deploy playStatistics --runtime nodejs8 --trigger-http
gcloud functions deploy generateStatistics --runtime nodejs8 --trigger-http