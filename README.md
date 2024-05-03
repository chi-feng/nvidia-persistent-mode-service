To enable persistent mode permanently on NVIDIA GPUs so that it persists across reboots, you can use one of the following methods:

### 1. Systemd Service (Recommended for Linux Systems)

You can create a custom systemd service that runs the `nvidia-smi -pm 1` command at boot. This is a robust way to ensure that the setting is applied consistently every time the system starts. Here’s how you can do it:

1. **Create a systemd service file:**
   Open a terminal and use a text editor to create a new service file under `/etc/systemd/system/`. For instance, you might call the file `nvidia-persistent-mode.service`.

   ```bash
   sudo nano /etc/systemd/system/nvidia-persistent-mode.service
   ```

2. **Add the following content to the file:**
   ```ini
   [Unit]
   Description=Enable NVIDIA GPU Persistent Mode
   After=syslog.target

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/nvidia-smi -pm 1

   [Install]
   WantedBy=multi-user.target
   ```

3. **Reload systemd to recognize the new service:**
   ```bash
   sudo systemctl daemon-reload
   ```

4. **Enable the service so it starts at boot:**
   ```bash
   sudo systemctl enable nvidia-persistent-mode.service
   ```

5. **Start the service immediately to apply the change without rebooting:**
   ```bash
   sudo systemctl start nvidia-persistent-mode.service
   ```

### 2. Cron Job at Reboot

Alternatively, you can use `cron` to run

the `nvidia-smi -pm 1` command at reboot. This method involves editing the crontab to add a reboot job.

1. **Open the crontab for editing:**
   ```bash
   sudo crontab -e
   ```

2. **Add the following line to the end of the crontab file:**
   ```bash
   @reboot /usr/bin/nvidia-smi -pm 1
   ```

3. **Save and close the file.**
   The cron job will now execute the `nvidia-smi -pm 1` command every time the system boots up.

### 3. RC Local (Legacy Method)

For systems that still support `rc.local` for startup scripts, you can add the `nvidia-smi -pm 1` command to the `rc.local` file, which is executed at the end of the multi-user runlevel.

1. **Edit the `rc.local` file:**
   ```bash
   sudo nano /etc/rc.local
   ```

2. **Add the following line before the `exit 0` line:**
   ```bash
   /usr/bin/nvidia-smi -pm 1
   ```

3. **Make sure that `rc.local` is executable:**
   ```bash
   sudo chmod +x /etc/rc.local
   ```

4. **Enable the `rc-local` service if it is not already enabled (systemd systems):**
   ```bash
   sudo systemctl enable rc-local
   ```

### Choosing a Method

- **Systemd Service**: This is the most robust and recommended method for modern Linux systems that use systemd.
- **Cron Job**: This is a simple and effective method that works across various types of systems but is generally less preferred than using systemd.
- **RC Local**: This is a legacy method and should only be used if you are on an older system that does not support systemd.

Using any of these methods, you can ensure that NVIDIA's persistent mode is enabled automatically every time your system boots, reducing GPU initialization time for your applications.
