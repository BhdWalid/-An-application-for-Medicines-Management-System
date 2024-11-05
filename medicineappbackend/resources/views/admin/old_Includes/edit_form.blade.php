<!-- Form Basic -->

<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Upadte A Teacher</h6>
   update {{$teacher['teacher_first_name']}}  {{$teacher['teacher_last_name']}}
</div>
<div class="card-body">
  <form>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">ID<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" required name="teacher_id" value="{{$teacher['teacher_id']}}">
        <span id="teacher_id_error" class="invalid-feedback"></span>
      </div>
        <input type="hidden" class="form-control" required name="teacher_old_id" value="{{$teacher['teacher_id']}}">
      <div class="col-xl-6">
        <label class="form-control-label">Firstname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_first_name" value="{{$teacher['teacher_first_name']}}">
        <span id="teacher_first_name_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Lastname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_last_name" value="{{$teacher['teacher_last_name']}}">
        <span id="teacher_last_name_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Grade<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_grade" value="{{$teacher['teacher_grade']}}">
        <span id="teacher_grade_error" class="invalid-feedback"></span>
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">Email Address<span class="text-danger ml-2">*</span></label>
        <input type="email" class="form-control" required name="teacher_email" value="{{$teacher['teacher_email']}}">
        <span id="teacher_email_error" class="invalid-feedback"></span>
      </div>
     
      <div class="col-xl-6">
        <label class="form-control-label">Phone<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" name="teacher_phone" value="{{$teacher['teacher_phone']}}">
        <span id="teacher_phone_error" class="invalid-feedback"></span>
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <button id="update" type="button" class="btn btn-warning" >Update</button>
      </div>
    </div>
  </form>
</div>