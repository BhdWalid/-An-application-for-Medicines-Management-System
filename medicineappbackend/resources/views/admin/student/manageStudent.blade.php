<!--non-changing part-->
@include("admin.Includes.topLayout")

<!-- Container Fluid-->
<div class="container-fluid" id="container-wrapper">
  @if (session('success'))
  <div class="alert alert-success text-center" role="alert">
    {{ session('success') }}
  </div>
  @endif
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Manage Accounts</h1>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="{{route('dashboard')}}">Home</a></li>
      <li class="breadcrumb-item active" aria-current="page">Manage Accounts</li>
    </ol>
  </div>
  <!-- Container Form -->
  <div class="row">
    <div class="col-lg-12">

      <div id="formContainer" class="card mb-4">
        @include('admin.student.create_form')
      </div>
      <!-- Input Group -->
      <div class="row">
        <div class="col-lg-12">
          <div class="card mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary">All Accounts</h6>
            </div>
            <div class="table-responsive p-3">
              <table class="display table align-items-center table-flush table-hover" id="dataTableHover">
                <thead class="thead-light">
                  <tr>
                    <th>#</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>Address</th>
                    <th>Status</th>
                    <th>Type User</th>
                    <th data-sortable='false'>Edit</th>
                    <th data-sortable='false'>Delete</th>
                  <!--  <th data-sortable='false'>Update Password</th> -->
                  </tr>
                </thead>

                <tbody>
                  <!-- DB -->
                  <!-- sample -->
                  @foreach ($students as $student)
                  <tr>
                    <td>{{$student['id_account']}}</td>
                    <td>{{$student['first_name']}}</td>
                    <td>{{$student['last_name']}}</td>
                    <td>{{$student['email']}}</td>
                    <td>{{$student['phone_number']}}</td>
                    <td>{{$student['address']}}</td>
                    <td>{{$student['status']}}</td>
                    <td>{{$student['type_user']}}</td>
                    <td><i class='purple-icon fas fa-fw fa-edit' data-student-id="{{$student['id_account']}}" id='editButton'></i></td>
                    <td><i class='purple-icon fas fa-fw fa-trash' data-student-id="{{$student['id_account']}}" data-student-full_name="{{$student['first_name']}}   {{$student['last_name']}}" data-toggle="modal" data-target="#exampleModal" id='deleteButton'></i></td>
                    <!-- <td><a href="route('editStudentPassword',['id'=>$student['id_account']])}}" class='btn btn-primary'>Edit</a></td>-->
                  </tr>
                  @endforeach
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
  <!-- Container Form -->


  <!---Container Fluid-->
</div>

<!--non-changing part-->
@include("admin.Includes.bottomLayout")

<!-- Page level custom scripts -->
<script>
  $(document).ready(function() {
    let updateTrElement;

    var table = $('#dataTableHover').DataTable({
      columnDefs: [{
        "defaultContent": "-",
        "targets": "_all"
      }],
    }); // ID From dataTable with Hover

    $("#submit").on("click", function() {
      emptyErrorSpan();

      let allData = {};

      $.each($('form').serializeArray(), function(i, field) {
        allData[field.name] = field.value;
      });

      $.post("{{route('storeStudent')}}", {
        '_token': "{{csrf_token()}}",
        'data': allData
      }, function(response) {
        if (response.status) {
          let tr = [];

          $.each(allData, function(index, value) {
            if (index == 'student_password') {
              return;
            }
            tr.push(value);
          });

          tr.push(`<i class='purple-icon fas fa-fw fa-edit' data-student-id="${allData.student_id}" id='editButton'></i>`);
          tr.push(`<i class='purple-icon fas fa-fw fa-trash' data-student-id="${allData.student_id}" data-student-full_name="${allData.student_first_name}  ${allData.student_last_name}" data-toggle="modal" data-target="#exampleModal" id='deleteButton'></i>`);

          let url = `{{route('editStudentPassword',['id'=>128])}}`;
          url = url.replace('128', allData.student_id);
          tr.push(`<a href="${url}" class='btn btn-primary'>Edit</a>`);

          table.row.add(tr).draw();

          resetForm();
        } else {
          displayErrorMessage(response.message);
          fillErrorSpan(response.errors);
        }
      });
    });

    $(document).on("click", "#deleteButton", function() {
      let trElement = $(this).parent().parent();
      let studentId = $(this).attr('data-student-id');
      let full_name = $(this).attr('data-student-full_name');

      var YOUR_MESSAGE_STRING_CONST = `Do You want to Delete Student <b>${full_name}</b>`;

      confirmDialog(YOUR_MESSAGE_STRING_CONST, function() {
        console.log(studentId);

        $.post("{{route('destroyAccount')}}", {
          _token: "{{csrf_token()}}",
          student_id: studentId
        }, function(response) {
          if (response.status) {
            table.row(trElement).remove().draw();
          } else {
            displayErrorMessage(response.message);
            console.log(response.errors);
          }
        });
      });

      function confirmDialog(message, onConfirm) {
        var fClose = function() {
          modal.modal("hide");
        };
        var modal = $("#confirmModal");
        modal.modal("show");
        $("#confirmMessage").empty().append(message);
        $("#confirmOk").unbind().one('click', onConfirm).one('click', fClose);
        $("#confirmCancel").unbind().one("click", fClose);
      }
    });

    $(document).on("click", "#editButton", function() {
      updateTrElement = $(this).parent().parent();
      let studentId = $(this).attr('data-student-id');

      $.post("{{route('editStudent')}}", {
        '_token': "{{csrf_token()}}",
        'student_id': studentId
      }, function(response) {
        if (response.status) {
          $('#formContainer').html(response.view);
          $('#formContainer')[0].scrollIntoView();
        } else {
          displayErrorMessage(response.message);
        }
      });
    });

    $(document).on('click', '#update', function() {
      emptyErrorSpan();

      let allData = {};
      $.each($('form').serializeArray(), function(i, field) {
        allData[field.name] = field.value;
      });

      $.post("{{route('updateStudent')}}", {
        '_token': "{{csrf_token()}}",
        'data': allData
      }, function(response) {
        if (response.status) {
          let tr = [];
          let studentId;

          $.each(allData, function(index, value) {
            if (index == 'id_account') {
              return;
            }
            tr.push(value);
          });

          tr.push(`<i class='purple-icon fas fa-fw fa-edit' data-student-id="${allData.id_account}" id='editButton'></i>`);
          tr.push(`<i class='purple-icon fas fa-fw fa-trash' data-student-id="${allData.id_account}" data-student-full_name="${allData.first_name}  ${allData.last_name}" id='deleteButton'></i>`);
          
    

          table.row(updateTrElement).data(tr).draw();
          $('#formContainer').html(response.view);
          $('table')[0].scrollIntoView();
          resetForm();
        } else {
          displayErrorMessage(response.message);
          fillErrorSpan(response.errors);
        }
      });
    });

    function resetForm() {
      $(':input', 'form')
        .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
    }

    function emptyErrorSpan() {
      for (const span of $('.invalid-feedback')) {
        span.innerHTML = '';
        span.parentElement.querySelector('input').classList.remove("is-invalid");
      }
      $('.alert.alert-danger').remove();
    }

    function fillErrorSpan(errors) {
      $.each(errors, function(key, value) {
        let span = $("#" + key + "_error");
        let input = span.parent().find("input").addClass('is-invalid');
        span.html(value[0]);
      });
    }

    function displayErrorMessage(message) {
      if ($('.alert.alert-danger').length) {
        $('.alert.alert-danger').html(message);
      } else {
        $('#container-wrapper').prepend(
          `<div class="alert alert-danger" role="alert">
             ${message}
           </div>`
        );
      }
    }
  });
</script>
</body>

</html>
