#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns 
from encodings.aliases import aliases 

get_ipython().run_line_magic('matplotlib', 'inline')


# In[2]:


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


# In[ ]:




