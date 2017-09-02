$(document).on('turbolinks:load', function() {
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 100, // Creates a dropdown of 15 years to control year
    max: new Date(),
    startYear: 1980,
    monthsFull:  ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    weekdaysFull: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
    weekdaysShort:  ["日", "月", "火", "水", "木", "金", "土"],
    weekdaysLetter: ["日", "月", "火", "水", "木", "金", "土"],
    labelMonthNext: "翌月",
    labelMonthPrev: "前月",
    labelMonthSelect: "月を選択",
    labelYearSelect: "年を選択",
    today: "本日",
    clear: "クリア",
    close: "閉じる",
    format: "yyyy-mm-dd",
    closeOnSelect: true, // Close upon selecting a date,
    onOpen: function() {
        this.set( 'select', [1980, 0, 1] );
    }
  });

  $('select').material_select();
});
