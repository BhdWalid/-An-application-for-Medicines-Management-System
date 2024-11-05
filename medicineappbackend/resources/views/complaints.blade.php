<!--non-changing part-->
@include("admin.Includes.topLayout")

<!--changing part-->
<div class="container-fluid" id="container-wrapper">
  <!-- Container Fluid-->
  <!--changing part-->
  @if (session('success'))
  <div class="alert alert-success text-center" role="alert">
    {{ session('success') }}
  </div>
  @endif
  @if (session('errors'))
  <div class="alert alert-danger text-center" role="alert">
    {{ session('errors')->first() }}
  </div>
  @endif
  <!-- Container Fluid-->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <!--header-->
    <h1 class="h3 mb-0 text-gray-800">Display Complaints</h1>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="./">Home</a></li>
      <li class="breadcrumb-item active" aria-current="page">Display Complaints</li>
    </ol>
  </div>

  <!--header-end-->

  <div class="row">
    <div class="col-lg-12">
      <div class="card mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">All complaints</h6>
        </div>
        <div class="table-responsive p-3">
          <table class="display table align-items-center table-flush table-hover" id="dataTableHover">
            <thead class="thead-light">
              <tr>
                <th>Number of complaint</th>
                <th>Sender </th>
                <th>Receiver</th>
                <th>Subject</th>
                <th>Content</th>
                <th>Date</th>
                <th>Delete</th>
              </tr>
            </thead>

            <tbody>
              @foreach($complaints as $complaint)
              <tr>
                <td>{{ $complaint->id_complaint }}</td>
                <td>{{ $complaint->sender }}</td>
                <td>{{ $complaint->resiver }}</td>
                <td>{{ $complaint->subject }}</td>
                <td>{{ $complaint->content }}</td>
                <td>{{ $complaint->date }}</td>
                <td><i id='deleteButton' data-student-id="{{$complaint['id_complaint']}}" data-student-full_name="{{$complaint['subject']}} " data-toggle="modal" data-target="#exampleModal" class='purple-icon fas fa-fw fa-trash'></i></td>
                @endforeach
            </tbody>
          </table>
        </div>
        <div class='py-3 px-3'>

          @csrf


        </div>
      </div>
    </div>
  </div>
  <!--Row-->
  <div class="container">
    <!-- Trigger the modal with a button -->
    <!-- <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button> -->
    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalCenterTitle">Modal title</h5>
            <button type="button" class="close" data-dismiss="modal">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <embed src="" frameborder="0" width="100%" height="550px" id="src_file">

            @csrf
            <div class="modal-footer">
              <div class="col-sm-6" id="simple-date4">
                <div class="input-daterange form-group input-group">
                  <input type="text" class="input-sm form-control" name="start_at" value="2022-11-29" id="start_at">
                  <div class="input-group-prepend">
                    <span class="input-group-text">to</span>
                  </div>
                  <input type="text" class="input-sm form-control" name="end_at" value="2022-11-30" id="end_at">
                </div>
              </div>
              <input type="hidden" name='student_id' value='' id="student_id">
              <input type="hidden" name='justification_id' value='' id="justification_id">
              <button type="submit" class="col-sm-3 form-group btn btn-outline-primary " name="decide" value="refuse">Deny</button>
              <button type="submit" class="col-sm-3 form-group btn btn-primary " name="decide" value="accepte">Approve</button>
            </div>
            </form>
          </div>

        </div>
      </div>
    </div>
  </div>
</div><!-- Container-Fluid-end-->

<!--changing part-->
@include ("admin.Includes.bottomLayout")
<!--non-changing part-->

<script>
  $(document).ready(function() {
    var allData = {}
    var table = $('#dataTableHover').DataTable({
      order: [
        [4, 'asc']
      ],
    }); // ID From dataTable with Hover
    $(document).on('click', '#btn', function() {
      justification_src = $(this).attr("data-justification-src");
      student_id = $(this).attr("data-student-id");
      justification_id = $(this).attr("data-justification-id");
      $('#src_file').attr("src", justification_src);
      $('#student_id').attr("value", student_id);
      $('#justification_id').attr("value", justification_id);
    })

    // $(document).on('click', '.decision', function() {
    //   decision=$(this).attr("value")
    //   $.each($('form').serializeArray(), function(i, field) {
    //     allData[field.name] = field.value;
    //   });
    //   allData['decision'] = decision;

    //    {
    //     '_token': "{{csrf_token()}}",
    //     'data': allData
    //   }, function(response) {
    //     console.log(response);
    //   })
    // })

    $("#submit").on("click", function() {
      emptyErrorSpan()

      let allData = {

      };

      $.each($('form').serializeArray(), function(i, field) {
        allData[field.name] = field.value;
      });

      $.post("{{route('storeStudent')}}", {
        '_token': "{{csrf_token()}}",
        'data': allData
      }, function(response) {

        if (response.status) {

          let tr = []

          $.each(allData, function(index, value) {
            if (index == 'student_password') {
              return;
            }
            tr.push(value);

          });

          tr.push(`<i id='editButton' data-student-id="${allData.student_id}" class='purple-icon fas fa-fw fa-edit'></i>`);
          tr.push(`<i id='deleteButton' data-student-id="${allData.student_id}" data-student-full_name="${allData.student_first_name}  ${allData.student_last_name}" data-toggle="modal" data-target="#exampleModal" class='purple-icon fas fa-fw fa-trash'></i>`);

          let url = `{{route('editStudentPassword',['id'=>128])}}`;
          url = url.replace('128', allData.student_id);
          tr.push(`<a href="${url}" class='btn btn-primary'>Edit</a>`);
          table.row.add(tr).draw();

          resetForm()

        } else {
          displayErrorMessage(response.message)
          fillErrorSpan(response.errors);

        }
      });
    });
    $(document).on("click", "#deleteButton", function() {


      let trElement = $(this).parent().parent();
      let studentId = $(this).attr('data-student-id')
      let full_name = $(this).attr('data-student-full_name')

      var YOUR_MESSAGE_STRING_CONST = `Do You want to Delete complaint of subject : <b>${full_name}</b>`;

      confirmDialog(YOUR_MESSAGE_STRING_CONST, function() {

        console.log(studentId);

        $.post("{{route('destroyComplaint')}}", {
          _token: "{{csrf_token()}}",
          student_id: studentId
        }, function(response) {


          if (response.status) {
            table.row(trElement).remove().draw();
          } else {
            displayErrorMessage(response.message)

            console.log(response.errors);
          }
        })

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
      $('.alert.alert-danger').remove()
    }

    function fillErrorSpan(errors) {
      $.each(errors, function(key, value) {
        let span = $("#" + key + "_error");
        let input = span.parent().find("input").addClass('is-invalid')
        span.html(value[0])
      });
    }

    function displayErrorMessage(message) {
      if ($('.alert.alert-danger').length) {
        $('.alert.alert-danger').html(message)
      } else {
        $('#container-wrapper').prepend(
          `
          <div class="alert alert-danger" role="alert">
          ${message}
          </div>
          `
        )
      }
    }
  })
</script>