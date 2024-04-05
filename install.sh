# install py dependencies 
python -m venv venv 
source venv/bin/activate 
pip install -r requirements.txt 

# pull anima docker 
docker pull sergeicu/anima


# To perform isotropic resampling (as shown in example.sh) 
# Make sure that crkit docker image is installed. It is currently installed on `ganymede` machine. 
# To pull crkit docker to any other machine - you can find it here - 
docker pull ccts3.aws.chboston.org:5151/computationalradiology/crkit
# if you do not have access to BCH internal `ccts3` website - make sure you ask someone who has 
