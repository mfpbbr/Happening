var geo;
var watchId;

var MAXIMUM_AGE = 200, TIMEOUT = 300000, HIGHACCURACY = true; 

function getGeoLocation() {
  try {
    if (!!navigator.geolocation) return navigator.geolocation;
    else return undefined;
  } catch (e) {
    return undefined;
  }
}

function setCookie(key, value) {
  document.cookie = key + "=" + escape(value);
}

function setError(errorMessage) {
  setCookie("geolocation_error", errorMessage);
  //alert(errorMessage);
}

function geo_error(error) {
  stopWatching();
  var errorMessage = '';
  switch(error.code) {
    case error.TIMEOUT:
      errorMessage = 'GeoLocation Timeout';
      break;
    case error.POSITION_UNAVAILABLE:
      errorMessage = 'GeoLocation Position Unavailable';
      break;
    case error.PERMISSION_DENIED:
      errorMessage = 'GeoLocation Permission denied';
      break;
    default:
      errorMessage = 'GeoLocation returned unknown error code:'+error.code;
      break;
  }

  setError(errorMessage);
}

function stopWatching() {
  if (watchId) geo.clearWatch(watchId);
  watchId = null;
}

function setGeoCookie(position) {
  var locationString = position.coords.longitude + "|" + position.coords.latitude;
  setCookie("lng_lat", locationString);
  setCookie("geolocation_error", "");
  //alert(locationString);
}

function startWatching() {
  watchId = geo.watchPosition(setGeoCookie, geo_error, {
    enableHighAccuracy: HIGHACCURACY,
    maximumAge: MAXIMUM_AGE,
    timeout: TIMEOUT
  });
}

window.onload = function() {
  if(geo = getGeoLocation()) {
    startWatching();
  } else {
    setError('GeoLocation not supported');
  }
}
