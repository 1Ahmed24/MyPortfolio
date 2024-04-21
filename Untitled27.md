```python
print('hww')
```

    hww
    


```python
import os
from subprocess import check_call

c = get_config()

def post_save(model, os_path, contents_manager):
    """post-save hook for converting notebooks to .py and .html files."""
    if model['type'] != 'notebook':
        return # only do this for notebooks
    d, fname = os.path.split(os_path)
    check_call(['ipython', 'nbconvert', '--to', 'script', fname], cwd=d)
    check_call(['ipython', 'nbconvert', '--to', 'html', fname], cwd=d)

c.FileContentsManager.post_save_hook = post_save
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    Cell In[5], line 4
          1 import os
          2 from subprocess import check_call
    ----> 4 c = get_config()
          6 def post_save(model, os_path, contents_manager):
          7     """post-save hook for converting notebooks to .py and .html files."""
    

    NameError: name 'get_config' is not defined



```python

```
