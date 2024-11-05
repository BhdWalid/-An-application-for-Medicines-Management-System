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
    <h1 class="h3 mb-0 text-gray-800">Manage Teachers</h1>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="{{route('dashboard')}}">Home</a></li>
      <li class="breadcrumb-item active" aria-current="page">Manage Teachers</li>
    </ol>
  </div>


  <!-- Container Form -->
  <div class="row">
    <div class="col-lg-12">

      <div id="formContainer" class="card mb-4">




        <!-- Form Basic -->
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">Create Students</h6>
          create new student
        </div>
        <div class="card-body">

          <form action="{{route('decide')}}" method="post">
            @csrf
            <input type="hidden" name="student_id" value="{{$id}}">
            <input type="hidden" name="justification_id" value="{{$justification_id}}">
            <div>
              <img src="{{$path}}" style="max-width: 100%;">
              {{-- <div id="pdf">
            <object width="100%" height="650" type="application/pdf" data="[{{$path}}]#zoom=85&scrollbar=0&toolbar=0&navpanes=0" id="pdf_content" style="pointer-events: none;">
              </object>
            </div> --}}
        </div>
        <div>
          <input type="submit" id="accepte" name="decision" value="accepte">
          <input type="submit" id="refuse" name="decision" value="refuse">
          <input type="date" name="start_at" value="{{$start_at}}">
          <input type="date" name="end_at" value="{{$end_at}}">
        </div>
        </form>
      </div>




    </div>
    <!-- Input Group -->

  </div>

</div>
<!-- Container Form -->


<!---Container Fluid-->
</div>


<!--non-changing part-->
@include("admin.Includes.bottomLayout")

<!-- Page level custom scripts -->

<script> 
    var allData={};
    var student_id =$("#student_id").val();
    var justification_id=$("#justification_id").val();
    allData['student_id']=student_id;
    allData['justification_id']=justification_id;
      $(document).on("click","#accepte",function(){
        allData['justification_status']=true;
        allData['absence_status']=true;
    $.post("{{url('decide')}}",
{data:allData,'_token': "{{csrf_token()}}",},function( data ){
} )
}
);

$(document).on("click","#refuse",function(){
allData['justification_status']=true;
allData['absence_status']=false;
$.post("{{url('decide')}}",
{data:allData,'_token': "{{csrf_token()}}",},function( data ){
} )
}
);

</script>