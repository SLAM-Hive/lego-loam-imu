### Build the LOAM Dockerfile
Firstly, git clone the algorithm Dockerfile repository to your computer, then:
```
cd loam_velodyne
./install.sh
```
You can check whether the image is successfully built as follows:
```
docker images
```
you can see:
```
slam-hive-algorithm lego-loam-imu [IMAGE ID] [CREATED] [SIZE]
```
