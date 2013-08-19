var activeElement;
var activeTextTimer = 0;
var activeOtherTimer = 0;
i=0;

function startPage(){
    window.setInterval(observe, 1000);
    
    document.onchange       = c;
    document.onkeyup        = t;
    window.onbeforeunload   = x;
}

function c(e){
    x = e.target
    if (x.id=="sid"){
        return;
    }
    if (x.id.match(/field_id____/)){
        return;
    }
    //alert(x)
    
    updateMessageBox("")
    if (x.id){
        setDefaultBorder(x.id)
    }
    if ((activeTextTimer > 0) && (x.id != activeElement || e.type == "change")){
        saveActiveElement();
        activeTextTimer = 0;
    }
    else if (x.type == "text" || x.type == "textarea"){
        setSpinner()
        activeTextTimer   = 1;
        if (activeElement && activeOtherTimer > 0){
            saveActiveElement();
            activeOtherTimer = 0;
        }
        activeElement     = x.id;
    }
    if ((activeOtherTimer > 0) && (x.id != activeElement)){
        saveActiveElement();
        activeOtherTimer = 0;
    }
    if ((x.type != "text" && x.type != "textarea") && e.type == "change"){
        setSpinner()
        activeOtherTimer  = 1;
        activeElement     = x.id;
    }
}

function t(e){
    c(e);
}

function x(e){
    getPage = document.getElementById("get_page")
    if(!getPage){
        if (activeTextTimer > 0 || activeOtherTimer > 0){
            saveActiveElement();
            return false;
        }
    }
}

function saveActiveElement(){
    send(activeElement);
}
    
function observe(){
    //if (i < 7) alert(activeTextTimer);
    //document.getElementById('test1').innerHTML = "Active Element: " + activeElement + " " + "Text Timer: " + activeTextTimer
    //document.getElementById('test2').innerHTML = "Active Element: " + activeElement + " " + "Other Timer: " + activeOtherTimer
    i+=1;
    if (activeTextTimer >= 6){
        saveActiveElement();
        activeTextTimer  = 0;
    }
    else if (activeTextTimer > 0){
        activeTextTimer += 1;
    }
    if (activeOtherTimer >= 3){
        saveActiveElement();
        activeOtherTimer = 0;
    }
    else if (activeOtherTimer > 0){
        activeOtherTimer += 1;
    }
}