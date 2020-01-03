# Oracle Database on Docker
### How-to run Oracle Database Enterprise 12c from a Docker container



!!! info "Host Machine used for testing:"
    OS: Ubuntu 19.10 
    
    Platform: x64
    
    Shell: Zsh

### Prerequisites:

* Dockerhub account(Free)
    * [Create account](https://hub.docker.com/)
    
* Docker installed 
    * [Instructions]( https://docs.docker.com/install/linux/docker-ce/#install-docker-engine---community )


!!! note "Check Docker installed correctly"
    ```bash
    docker --version
    ```

    ##### Should output something like:

    `Docker version 19.03.2, build 6a30dfca03`

!!! note "Login to your DockerHub from CLI"
    ```bash
    docker login
    ```
    
    ##### Should launch a webrowser to auhenticate your CLI session 

## Pull the Oracle Docker Image

Oracle is very strict about it's licensing which is why the Dockerhub account is required.  

* Navigate to https://hub.docker.com/_/oracle-database-enterprise-edition . 
* Click the Proceed To Checkout 
* You'll be prompted to login to Dockerhub if you're not already
* ^^Carefully^^ read and accept the license(s) if you agree to them. 

After agreeing to the licenses, you'll be redirected to a page that has the `docker pull` command to get the image and
some setup instructions.  Ignore the setup instructions for now and pull the Docker image 

!!! note "Pull the Docker Image"
    ##### This is the command at the time of writing
    ```bash
    docker pull store/oracle/database-enterprise:12.2.0.1
    ```

!!! info "Verify you have the image"
    ```bash
    docker images | grep oracle
    ```
    
    `store/oracle/database-enterprise                                12.2.0.1                                   12a359cd0528        2 years ago         3.44GB`
    







