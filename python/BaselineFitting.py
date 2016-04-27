import scipy.interpolate as sci
import numpy as np
from matplotlib.pyplot import plot

def BaselineFitting(resource, PMIN, TMIN):
    new_x = np.arange(0, resource.size, 1);
    new_y = sci.spline(TMIN,PMIN,new_x);
    re = resource-new_y;
    return re;
