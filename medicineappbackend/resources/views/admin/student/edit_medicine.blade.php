
<!-- Form Basic -->
<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Update Medicine</h6>
  Update {{$medicine['name_medicine']}}
</div>
<div class="card-body">
  <form>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">ID<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" required name="id_medicine" value="{{$medicine['id_medicine']}}">
        <span id="id_medicine_error" class="invalid-feedback"></span>
      </div>
      <input type="hidden" class="form-control" required name="old_id_medicine" value="{{$medicine['id_medicine']}}">
      <div class="col-xl-6">
        <label class="form-control-label">Medicine Name<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="name_medicine" value="{{$medicine['name_medicine']}}">
        <span id="name_medicine_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Bar Code<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="bar_code" value="{{$medicine['bar_code']}}">
        <span id="bar_code_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Price<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="price" value="{{$medicine['price']}}">
        <span id="price_error" class="invalid-feedback"></span>
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Image</label>
        <input type="text" class="form-control" name="image" value="{{$medicine['image']}}">
        <span id="image_error" class="invalid-feedback"></span>
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <button id="update" type="button" class="btn btn-warning">Update</button>
      </div>
    </div>
  </form>
</div>
