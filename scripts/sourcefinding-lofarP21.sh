# this script fixes permissions inside the docker container, downloads data, and runs a python source-fiding script.

# fix permissions
chmod 755 * -R

# download data
wget https://vo.astron.nl/getproduct/hetdex/data/low-mosaics/P21-low-mosaic.fits

# run the source-finding
python3 source-finding.py P21-low-mosaic.fits
