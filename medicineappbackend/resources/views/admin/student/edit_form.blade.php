<!-- Form Basic -->
<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Update An Account</h6>
   Update {{$student['first_name']}} {{$student['last_name']}}
</div>
<div class="card-body">
  <form>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">ID<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" required name="id_account" value="{{$student['id_account']}}">
        <span id="id_account_error" class="invalid-feedback"></span>
      </div>
      <input type="hidden" class="form-control" required name="old_id_account" value="{{$student['id_account']}}">
      <div class="col-xl-6">
        <label class="form-control-label">First Name<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="first_name" value="{{$student['first_name']}}">
        <span id="first_name_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Last Name<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="last_name" value="{{$student['last_name']}}">
        <span id="last_name_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Email Address<span class="text-danger ml-2">*</span></label>
        <input type="email" class="form-control" required name="email" value="{{$student['email']}}">
        <span id="email_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Phone Number</label>
        <input type="tel" class="form-control" name="phone_number" value="{{$student['phone_number']}}">
        <span id="phone_number_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Address</label>
        <input type="text" class="form-control" name="address" value="{{$student['address']}}">
        <span id="address_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Status</label>
        <select required name="status" class="form-control mb-3">
          <option value="accept" @if($student['status'] == 'accept') selected @endif>accept</option>
          <option value="pending" @if($student['status'] == 'pending') selected @endif>pending</option>
        </select>
        <span class="text-danger" id="status_error"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Type User</label>
        <select required name="type_user" class="form-control mb-3">
          <option value="pharmacist" @if($student['type_user'] == 'pharmacist') selected @endif>pharmacist</option>
          <option value="doctor" @if($student['type_user'] == 'doctor') selected @endif>doctor</option>
          <option value="patient" @if($student['type_user'] == 'patient') selected @endif>doctor</option>
        </select>
        <span class="text-danger" id="type_user_error"></span>
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <button id="update" type="button" class="btn btn-warning">Update</button>
      </div>
    </div>
  </form>
</div>
