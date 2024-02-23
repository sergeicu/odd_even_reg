# install py dependencies 
python -m venv venv 
source venv/bin/activate 
pip install -r requirements.txt 

# pull anima docker 
docker pull sergeicu/anima
