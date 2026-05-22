# Morphological classification of eclipsing binaries from Gaia DR3

    This resource provides the results of a morphological classification of 2,184,283 eclipsing binary candidates 
    from the Gaia DR3 catalogue. The systems are classified into detached and overcontact configurations, 
    followed by the identification of starspot signatures within both morphological classes.

    The classification was performed using a hierarchical computer-vision pipeline based on a fine-tuned ResNet-18 
    convolutional neural network trained on synthetic light curves generated with the ELISa code. 
    The phase-folded Gaia G-band light curves are represented as 3-channel 128×128 pixel images encoding 
    the flux distribution, its polar transformation, and the flux gradient.

    A tailored augmentation scheme calibrated to the Gaia cadence distribution was applied to reduce 
    the synthetic-to-real domain gap (in prep).
     
 