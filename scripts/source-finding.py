import bdsf
import sys
from astropy.io import fits

def do_sourcefinding(imagename):
    # get beam info manually. SKA image seems to cause PyBDSF issues finding this info.
    hdu = fits.open(imagename, mode='update')
    beam_maj = hdu[0].header['BMAJ']
    beam_min = hdu[0].header['BMIN']
    #beam_pa = hdu[0].header['BPA'] # not in SKA fits header, but we know it's circular
    beam_pa = 0
    # set rms_box as 30 beams in pixels
    pixperbeam = beam_maj/hdu[0].header['CDELT2']
    print(pixperbeam)
    hdu.close()
    # Run sourcefinding using some sensible hyper-parameters. PSF_vary and adaptive_rms_box is more computationally intensive, off for now
    img = bdsf.process_image(imagename, adaptive_rms_box=False, advanced_opts=True,\
        atrous_do=False, psf_vary_do=False, psf_snrcut=5.0, psf_snrcutstack=10.0,\
        output_opts=True, output_all=True, opdir_overwrite='append', beam=(beam_maj, beam_min, beam_pa), frequency=120000000,\
        blank_limit=None, thresh='hard', thresh_isl=4.0, thresh_pix=5.0, psf_snrtop=0.30,\
        rms_map=True, rms_box=(30*pixperbeam, 8*pixperbeam), do_cache=True) #
    # can save the img object as a pickle file, so we can do interactive checks after pybdsf has run
    # turns out this doesn't work you have to run it inside an interactive python session
    # save_obj(img, 'pybdsf_processimage_'+imagename[:-5])

do_sourcefinding(sys.argv[1])