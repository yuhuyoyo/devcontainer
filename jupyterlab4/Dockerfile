FROM  gcr.io/deeplearning-platform-release/tf-cpu.2-11.py310

RUN pip install -U jupyterlab

USER jupyter
WORKDIR /home/jupyter

ENTRYPOINT ["/usr/local/bin/jupyter", "lab", "--ip", "0.0.0.0", "--NotebookApp.allow_origin='*'"]
