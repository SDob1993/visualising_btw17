/**
 * Created by simon on 17.12.2017.
 */
//get elements
var slider3 = document.getElementById("sliderhash");
slider3.defaultValue=1;
var output2 = document.getElementById("valuehash");
output2.innerHTML = slider.value;
var hashoutput = document.getElementById("containertophashtags");

slider3.oninput = function() {
    output2.innerHTML = "Woche: "+ this.value;
};

function gettophash() { //adjust the int
    var week = document.getElementById("sliderhash").value;
    var partyh = document.getElementById("selectparty").value;
    week = parseInt(week);
    switch (week){
        case 1: week=6;
            break;
        case 2: week=5;
            break;
        case 3: week=4;
            break;
        case 4: week=3;
            break;
        case 5: week=2;
            break;
        case 6: week=1;
            break;
        case 7: week=0;
            break;
        case 8: week=-1;
            break;
        case 9: week=-2;
            break;
        case 10: week=-3;
            break;

    }

    d3.json("src/json/topHashtags5.json", function(error, data) {
        if (error) throw error;


        var hashtagarr = []; //create new array

        for(var i=0; i< data.length;i++){
            if((data[i]['party']==partyh)&&(data[i]['weeksTillElection']==week)){
                var object={
                    freq: data[i]['freq'],
                    hashtag: data[i]['hashtags']
                    //get data, create objects for the right variables week and party
                };
                hashtagarr.push(object);
                //push
            }
        }
        //sort by freq
        sortByFreq(hashtagarr,"freq");
        function sortByFreq(array, key) {
            return array.sort(function(a, b) {
                var x = a[key]; var y = b[key];
                return ((x > y) ? -1 : ((x < y) ? 1 : 0));
            });
        }
        hashoutput.innerHTML ="test";
        var top5 = "";
        //create top5 string with freq and right breaks
        for (i=0;i<hashtagarr.length;i++){
            top5 = top5.concat(""+(i+1)+". #"+hashtagarr[i].hashtag+" Anzahl:  "+hashtagarr[i].freq+"<br>");
        }
        hashoutput.innerHTML =top5; //set html
})}
