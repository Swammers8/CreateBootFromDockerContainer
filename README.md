# CreateBootFromDockerContainer

I made a script from commands taken from [here](https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/)
Example Usage:
```
./createbootfromtar.sh /home/kali/container.tar /os/new-img.img /dev/loop1
```
First arg is the existing exported container, second is the file that will be created, and the third is any loop that's free ex. /dev/loop0, /dev/loop1, /dev/loop2, etc.
