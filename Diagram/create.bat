cd ..\Submission
docker run --rm -it --name dcv -v .:/input pmsipilot/docker-compose-viz render -m image docker-compose.yml
cd ..\TRE
docker run --rm -it --name dcv -v .:/input pmsipilot/docker-compose-viz render -m image docker-compose.yml
cd ..\Diagram

