$(window).on('load', function() {
  createChartPDF(
    gon.lastDayOfMonth,
    gon.monthName,
    gon.requests,
    gon.errorRates,
    gon.responseTimes
  );
});

var createChartPDF = function (days, month, requests, errors, responses) {
  var DAYS = [];
  for (i = 0; i < days; i++) {
    DAYS[i] = (i+1 + month);

  }

  var chartData =[];
  for (i = 0; i < DAYS.length; i++) {
    chartData.push( {
      "day": DAYS[i],
      "responseTime": responses[i],
      "errorRate": errors[i],
      "requests": requests[i]
    });
  }

  var maxResponses = Math.ceil(Math.max.apply(null, responses) / 100) * 100;
  var maxErrorRate = Math.ceil(Math.max.apply(null, errors) / 20) * 20;

  AmCharts.makeChart("chartdiv",
    {
      "addClassNames": true,
      "type": "serial",
      "categoryField": "day",
      "colors": [
        "#008990",
        "#FF546A",
        "#B0DE09",
        "#0D8ECF"
      ],
      "startDuration": 0,
      "fontFamily": "SanukPro",
      "categoryAxis": {
        "gridThickness": 1,
        "gridColor": "#979A9B",
        "startOnAxis": true,
        "autoGridCount": false,
        "gridCount": 5,
        "showLastLabel": true
      },
      "chartCursor": {
        "enabled": true
      },
      "trendLines": [],
      "graphs": [
        {
          "balloonText": "[[title]]: [[value]] ms",
          "bullet": "none",
          "id": "responseGraph",
          "title": "Antwortzeit in ms",
          "valueField": "responseTime",
          "lineThickness": 1.5
        },
        {
          "balloonText": "[[title]]: [[value]] %",
          "bullet": "none",
          "id": "errorsGraph",
          "title": "Fehlerrate in %",
          "valueAxis": "errorAxis",
          "valueField": "errorRate",
          "lineThickness": 1.5
        }
      ],
      "guides": [
        {
          "label": maxResponses/4 + " ms",
          "inside": false,
          "lineColor": "#979A9B",
          "lineAlpha": 1,
          "value": maxResponses/4,
          "toValue": maxResponses/4,
          "valueAxis": "responseAxis",
          "tickLength": 0
        },
        {
          "label": maxResponses/2 + " ms",
          "inside": false,
          "lineColor": "#979A9B",
          "lineAlpha": 1,
          "value": maxResponses/2,
          "toValue": maxResponses/2,
          "valueAxis": "responseAxis",
          "tickLength": 0
        },
        {
          "label": (maxResponses/4)*3 + " ms",
          "inside": false,
          "lineColor": "#979A9B",
          "lineAlpha": 1,
          "value": (maxResponses/4)*3,
          "toValue": (maxResponses/4)*3,
          "valueAxis": "responseAxis",
          "tickLength": 0
        },
        {
          "label": maxResponses + " ms",
          "inside": false,
          "lineColor": "#979A9B",
          "lineAlpha": 1,
          "value": maxResponses,
          "toValue": maxResponses,
          "valueAxis": "responseAxis",
          "tickLength": 0
        },
        {
          "label": maxErrorRate/4 + " %",
          "inside": false,
          "lineAlpha": 0,
          "value": maxErrorRate/4,
          "toValue": maxErrorRate/4,
          "valueAxis": "errorAxis",
          "tickLength": 0
        },
        {
          "label": maxErrorRate/2 + " %",
          "inside": false,
          "lineAlpha": 0,
          "value": maxErrorRate/2,
          "toValue": maxErrorRate/2,
          "valueAxis": "errorAxis",
          "tickLength": 0
        },
        {
          "label": (maxErrorRate/4)*3 + " %",
          "inside": false,
          "lineAlpha": 0,
          "value": (maxErrorRate/4)*3,
          "toValue": (maxErrorRate/4)*3,
          "valueAxis": "errorAxis",
          "tickLength": 0
        },
        {
          "label": maxErrorRate + " %",
          "inside": false,
          "lineAlpha": 0,
          "value": maxErrorRate,
          "toValue": maxErrorRate,
          "valueAxis": "errorAxis",
          "tickLength": 0
        }
      ],
      "valueAxes": [
        {
          "id": "responseAxis",
          "maximum": maxResponses,
          "minimum": 0,
          "position": "left",
          "unit": " ms",
          "gridAlpha": 0,
          "labelsEnabled": false,
          "labelFrequency": 1000
        },{
          "id": "errorAxis",
          "maximum": maxErrorRate,
          "minimum": 0,
          "position": "right",
          "unit": " %",
          "gridAlpha": 0,
          "labelsEnabled": false,
          "labelFrequency": 1000
        }
      ],
      "allLabels": [],
      "balloon": {},
      "legend": {
        "enabled": true,
        "useGraphSettings": true,
        "valueText": ""
      },
      "titles": [],
      "dataProvider": chartData
    }
  );
}
