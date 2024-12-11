**Docker Compose Setup for Spark, Spark Worker, and Almond**
===========================================================

This Docker Compose setup provides a environment for running Apache Spark, a Spark worker, and Almond (a Jupyter notebook server) with shared storage using a Samba share.

**Step 1: Configure Environment Variables**
------------------------------------------

Make a copy of the `.env.example` file to `.env` and update the following variables:

* `SMB_USER`: Your Samba username
* `SMB_PASSWORD`: Your Samba password
* `SMB_URL`: The URL of your Samba share (e.g., `//server/share`)
* `SPARK_MASTER_URL`: Leave it as it is if you are running the master in the same machine. Otherwise, change it to the master IP and port.

> Do not commit the .env file with your credentials.

**Step 2: Set up Samba Share**
-----------------------------

To set up a Samba share, you'll need to create a shared directory on your host machine and configure Samba to share it. Here's a brief overview of the steps:

1. Create a shared directory on your host machine (e.g., `/shared/data`).
2. Install and configure Samba on your host machine.
3. Add a Samba user and set a password.
4. Configure the Samba share to use the `vers=3.0` option.

For more detailed instructions, refer to your operating system's documentation or a Samba setup guide.

**Step 3: Run Docker Compose**
-----------------------------

Once you've configured your environment variables and set up your Samba share, run the following command to start the Docker containers:

```bash
docker compose up
```

This will start the Spark master, Spark worker, and Almond containers in detached mode. In order to just start the worker in a different machine, do

```bash
docker compose spark-worker
```

Make sure the variable `SPARK_MASTER_URL` is pointing to the actual server.