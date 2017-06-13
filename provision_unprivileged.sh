#!/usr/bin/env bash

download_check_install_anaconda() {
  # download to host if necessary
  ANACONDA_URL=https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
  ANACONDA_INSTALLER=$(basename "$ANACONDA_URL")
  ANACONDA_INSTALLER_HASH_FILE="${ANACONDA_INSTALLER}.SHA256SUM"
  ANACONDA_DOWNLOAD_SUB_DIR="anaconda-download"
  ANACONDA_DOWNLOAD_PATH="/vagrant/$ANACONDA_DOWNLOAD_SUB_DIR/$ANACONDA_INSTALLER"
  wget --progress=bar:force --continue --output-document="$ANACONDA_DOWNLOAD_PATH"  --continue "$ANACONDA_URL"


  # copy to vm for faster installation
  VM_ANACONDA_INSTALLER_DIR="$HOME/$ANACONDA_DOWNLOAD_SUB_DIR"
  VM_ANACONDA_INSTALLER_PATH="$VM_ANACONDA_INSTALLER_DIR/$ANACONDA_INSTALLER"
  mkdir "$VM_ANACONDA_INSTALLER_DIR"
  cp "$ANACONDA_DOWNLOAD_PATH" "$VM_ANACONDA_INSTALLER_DIR/"

  # check
  echo -e "3301b37e402f3ff3df216fe0458f1e6a4ccbb7e67b4d626eae9651de5ea3ab63\t$VM_ANACONDA_INSTALLER_PATH" > "$VM_ANACONDA_INSTALLER_DIR/$ANACONDA_INSTALLER_HASH_FILE"
  sha256sum -c "$VM_ANACONDA_INSTALLER_DIR/$ANACONDA_INSTALLER_HASH_FILE"

  # install
  ENABLE_BATCH_MODE="-b"
  bash "$VM_ANACONDA_INSTALLER_PATH" "$ENABLE_BATCH_MODE"
}

extend_path_variable() {
  echo "PATH=\"\$PATH:$HOME/anaconda3/bin\"" >> "$HOME/.profile"
  . "$HOME/.profile"
}

enable_remote_jupyter_access() {
  jupyter notebook --generate-config
  echo "c.NotebookApp.ip = '*'" >> "$HOME/.jupyter/jupyter_notebook_config.py"
  cp /vagrant/jupyter_notebook_config.json "$HOME/.jupyter/"
}

provide_jupyter_access_to_vagrant_dir() {
  ln -s /vagrant "$HOME/vagrant_share"
}

download_check_install_anaconda
extend_path_variable
enable_remote_jupyter_access
provide_jupyter_access_to_vagrant_dir
