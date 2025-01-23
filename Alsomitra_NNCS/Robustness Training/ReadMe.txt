1. First, clone or download the Github Repo.

2. Navigate to the necessary directory location.

3. Create a virtual environment and run the following command in the terminal: "pip install -r requirements.txt" to install the necessary dependencies.

4. The simply run "python main.py" or "python3 main.py" depending on the version of python that you are running.


Vehicle commands: 

! vehicle \
  verify \
  --specification Alsomitra.vcl \
  --verifier Marabou \
  --verifier-location /home/ck2049/Desktop/Marabou/build/Marabou  \
  --network alsomitra:base_model.onnx \
  --property property1
