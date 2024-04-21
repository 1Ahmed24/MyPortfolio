.. code:: ipython3

    import pandas as pd
    import numpy as np
    import matplotlib.pyplot as plt
    import seaborn as sns 
    from encodings.aliases import aliases 
    
    %matplotlib inline

.. code:: ipython3

    # To find encodings that work
    
    # Below line creates a set of all available encodings
    encodings = ['utf-8', 'ISO-8859-1', 'latin1', 'cp1252']
    for encoding in encodings:
        try:
            df = pd.read_csv(r"C:\Users\ahmed\Downloads\crime.csv", encoding=encoding)
            print("File read successfully with encoding:", encoding)
            break
        except UnicodeDecodeError:
            print("Error reading with encoding:", encoding)


.. parsed-literal::

    Error reading with encoding: utf-8
    File read successfully with encoding: ISO-8859-1
    

