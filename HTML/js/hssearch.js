/**
 * Created by simon on 22.12.2017.
 */

function searchgo() {
    var hsoutput = document.getElementById("containerhssearch");
    var hssearched = document.getElementById("hssearch").value;

    d3.json("src/json/hssearch.json", function(error, data) {
        if (error) throw error;


        var hashco = [];
        //create new array and push objects with the second hashtag and the freqe
        for(var i=0; i< data.length;i++){
            if(data[i]['Hashtag1']==hssearched){
                var object={
                    hashtag: data[i]['Hashtag2'],
                    freq: data[i]['freq']

                };
                hashco.push(object);
            }
        }
        //sort by Frequency
        sortByFreq(hashco,"freq");
        function sortByFreq(array, key) {
            return array.sort(function(a, b) {
                var x = a[key]; var y = b[key];
                return ((x > y) ? -1 : ((x < y) ? 1 : 0));
            });
        }

        var search = "";
        for (i=0;i<hashco.length;i++){
            search = search.concat(""+(i+1)+". #"+hashco[i].hashtag+" Anzahl:  "+hashco[i].freq+"<br>");
        }
        hsoutput.innerHTML =search;


    })
}

/*
var suggs = document.getElementById("suggs");

function showsugg() {
    var searchin = document.getElementById("hssearch").value;
    var sugtext = "";
    console.log("test"+searchin);
    if(searchin.length>2){
    d3.json("src/json/hssearch.json", function(error, data) {
        if (error) throw error;
        for(var i=0; i< data.length;i++){
            if(data[i]['Hashtag1'].indexOf(searchin) !==-1){
                sugtext = sugtext.concat(data[i]['Hashtag1']+",")
                console.log(sugtext)
                }

            }
        });}


    suggs.innerHTML = "<b> Vorschläge: </b>"+sugtext;
}*/

