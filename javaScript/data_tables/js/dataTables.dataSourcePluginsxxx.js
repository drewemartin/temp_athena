$.fn.dataTableExt.afnSortData['dom-text'] = function ( oSettings, iColumn ){
    alert("!")
    var aData = [];
    $( 'td:eq('+iColumn+') input', oSettings.oApi._fnGetTrNodes(oSettings) ).each( function () {
        aData.push( this.value );
    });
    return aData;
};