var workflowMessages = ['Select the column for First Name.', 'Select the column for Last Name or <button class="btn btn-danger" id="undo"><span class="glyphicon glyphicon-chevron-left"></span> Go Back</button>', 'Select the column for Email or <button class="btn btn-danger" id="undo"><span class="glyphicon glyphicon-chevron-left"></span> Go Back</button>'];
var workflowIndex = 0;
var tableIndexes = [];
var info;

var postUserTable = function postUserTable() {
  var userData = [], fields = ['firstName', 'middleName', 'lastName', 'email'];
  $('#data-table tr').each(function (i) {
    if (i != 0) {
      var user = {};
      $(this).children().each(function (index) {
        user[fields[index]] = $(this).find('input').val() || null;
      });
      userData.push(user);
    }
  });
  $.ajax({
    type : "POST",
    url : "/addUsers",
    data: JSON.stringify({users: userData}, null, '\t'),
    contentType: 'application/json;charset=UTF-8',
    success: function(result) {
      $('#instruction-message').html('Done! The data has been added. If you need to add another file click here:<br><a class="btn btn-success" href="/bulkUpload">Upload Another File</a>');
      $('#data-table').slideUp();
      $('#submit-table-btn').hide();
    },
    error: function (error) {
      console.log('========== ERRROR ==========')
      console.log(error);
      console.log('============================')
    }
  });
};

var createEditingTable = function createEditingTable() {
  $('#data-table').html('');
  $('#data-table').append('<tr><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>Email</th></tr>');
  for (var row in info.data) {
    if (info.data.hasOwnProperty(row)) {
      var tableRow = '<tr>';
      for (var index in tableIndexes) {
        if (info.data[row].hasOwnProperty(index)) {
          tableRow += '<td><input type="text" value="' + info.data[row][tableIndexes[index]] + '"</td>';
          if (index == 0) {
            tableRow += '<td><input type="text value=""></input></td>';
          }
        }
      }
      tableRow += '</tr>';
      $('#data-table').append(tableRow);
    }
  }
  $('#table-area').append('<input type="submit" class="btn btn-danger" id="submit-table-btn"></input>');
  $('#submit-table-btn').click(postUserTable);
};

var undoSelection = function undoSelection() {
  var index = tableIndexes.pop();
  $('#data-table tr').each(function () {
    $(this).find('td:eq('+ index + ')').removeClass('success');
    $(this).find('th:eq('+ index + ')').removeClass('success');
  });
  workflowIndex -= 1;
  $('#instruction-message').html(workflowMessages[workflowIndex]);
  $('#undo').click(undoSelection);
}

var selectColumn = function selectColumn(event) {
  var column = $(event.currentTarget).index();
  tableIndexes.push(column);
  $(event.currentTarget).addClass('success');
  $('#data-table tr').each(function () {
    $(this).find('td:eq('+ column + ')').addClass('success');
  });
  workflowIndex += 1;
  if (workflowIndex < 3) {
    $('#instruction-message').html(workflowMessages[workflowIndex]);
    $('#undo').click(undoSelection);
  } else {
    $('#instruction-message').removeClass('alert-danger');
    $('#instruction-message').addClass('alert-success');
    $('#instruction-message').html('Thanks! Here is a table with your data. Fill in what you need then click submit.');
    createEditingTable();
  }
};

var setTableEvents = function setTableEvents() {
  $('#data-table tr th').click(selectColumn);
};

$(function() {
  var myDropzone = new Dropzone("#dropzone", {
    init: function () {
      this.on('success', function (file, response) {
        var row, value, headerRow = '<tr>';
        info = JSON.parse(response);
        for (row in info.headers) {
          headerRow += '<th>' + info.headers[row] + '</th>'
        }
        headerRow += '</tr>';
        $('#data-table').append(headerRow);
        for (row in info.data) {
          if (info.data.hasOwnProperty(row)) {
            var tableRow = '<tr>';
            for (value in info.data[row]) {
              if (info.data[row].hasOwnProperty(value)) {
                tableRow += '<td>' + info.data[row][value] + '</td>';
              }
            }
            tableRow += '</tr>'
            $('#data-table').append(tableRow);
            $('#instruction-message').html(workflowMessages[workflowIndex]);
            $('#instruction-message').slideDown();
            $('#dropzone').slideUp();
          }
        }
        setTableEvents();
      });
    }
  });
});
