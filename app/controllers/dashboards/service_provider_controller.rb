class Dashboards::ServiceProviderController < ApplicationController

  def index
    @doctorsactive = Doctor.where(status: 'ACTIVE').count
    @laboratoriesactive = Laboratory.where(status: 'ACTIVE').count
    @xrayfacilityactive = XrayFacility.where(status: 'ACTIVE').count
    @radiologistactive = Radiologist.where(status: 'ACTIVE').count
    @current_year = Date.today.year
    @doctornew = Doctor.where("extract(year from created_at) = ?", @current_year).count
    @laboratoriesnew = Laboratory.where("extract(year from created_at) = ?", @current_year).count
    @xrayfacilitynew = XrayFacility.where("extract(year from created_at) = ?", @current_year).count
    @radiologistnew = Radiologist.where("extract(year from created_at) = ?", @current_year).count

    @doctorwithdrawl = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where("doctors.status=? and status_schedules.status_reason IN(?)", 'INACTIVE', ["01", "02"]).count
    @laboratorywithdrawl = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
    @xrayfacilitywithdrawl = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
    @radiologistwithdrawl = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count

    @doctordemised = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @laboratorydemised = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @xrayfacilitydemised = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @radiologistdemised = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count

    @doctornoncomp = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @laboratorynoncomp = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @xrayfacilitynoncomp = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @radiologistnoncomp = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count

    @doctorstates = Doctor.joins(:state).where('doctors.status=?', 'ACTIVE').group('states.name').count
    @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=?', 'ACTIVE').group('states.name').count
    @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?', 'ACTIVE').group('states.name').count
    @radiologiststates = Radiologist.joins(:state).where('radiologists.status=?', 'ACTIVE').group('states.name').count

    @doctorquotausagezero = Doctor.where('quota_used=?', 0).count
    @doctorquotausage1to100 = Doctor.where('quota_used>0 and quota_used<=100').count
    @doctorquotausage101to200 = Doctor.where('quota_used>101 and quota_used<=200').count
    @doctorquotausage201to300 = Doctor.where('quota_used>201 and quota_used<=300').count
    @doctorquotausage301to400 = Doctor.where('quota_used>301 and quota_used<=400').count
    @doctorquotausage401to500 = Doctor.where('quota_used>401 and quota_used<=500').count
    @doctorquotausage501to600 = Doctor.where('quota_used>501 and quota_used<=600').count
    @doctorquotausage601to700 = Doctor.where('quota_used>601 and quota_used<=700').count
    @doctorquotausage701to800 = Doctor.where('quota_used>701 and quota_used<=800').count

    @certifydoctoroverallcount = Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").count
    @certifydoctorxrayyes = Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date  and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and extract(year from transactions.created_at) = ?", @current_year).count
    @certifydoctorlabyes = Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and extract(year from transactions.created_at) = ?", @current_year).count

    @certifydoctorxrayno = Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) > 1 and extract(year from transactions.created_at) = ?", @current_year).count
    @certifydoctorlabno = Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) > 1 and extract(year from transactions.created_at) = ?", @current_year).count

    @certifydoctorwithin24hours = (@certifydoctorxrayyes.count) + (@certifydoctorlabyes.count)
    @certifydoctorbeyond24hours = @certifydoctorxrayno.count + @certifydoctorlabno.count

    if (@certifydoctoroverallcount != nil)
      @ceritifydoctorperyestotal = (@certifydoctorwithin24hours)
      if (@certifydoctorbeyond24hours * 100 / @certifydoctoroverallcount.count < 15)
        @ceritifydoctorperyestotal = @ceritifydoctorperyestotal + 1
      else
        @ceritifydoctorperyestotal = @ceritifydoctorperyestotal + 0
      end
    else
      @ceritifydoctorperyestotal = 0
      @ceritifydoctorpernototal = 0
    end
    @laboratorydonutwithin48 = Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) < 2 and extract(year from transactions.created_at) = ?", @current_year).count
    @laboratorydonutbeyond48 = Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) > 2 and extract(year from transactions.created_at) = ?", @current_year).count

    @Xrayfacilitywithinhours24 = Transaction.joins("join xray_facilities on xray_facilities.id=transactions.xray_facility_id").joins("join xray_examinations on xray_examinations.transaction_id=transactions.id").where("xray_facilities.radiologist_operated='TRUE' and transactions.radiologist_id is null and xray_facilities.radiologist_operated='FALSE' and xray_examinations.xray_taken_date is not null and transactions.status not IN('CANCELLED','REJECTED') and DATE_PART('Day',transmitted_at - xray_taken_date) < 1").count
    @Xrayfacilitywithinhours48 = Transaction.joins("join xray_facilities on xray_facilities.id=transactions.xray_facility_id").joins("join xray_examinations on xray_examinations.transaction_id=transactions.id").where("xray_facilities.radiologist_operated='TRUE' and transactions.radiologist_id is not null and xray_facilities.radiologist_operated='FALSE' and xray_examinations.xray_taken_date is not null and transactions.status not IN('CANCELLED','REJECTED') and DATE_PART('Day',transmitted_at - xray_taken_date) < 2").count

    @xraytransmissionpercentage = @Xrayfacilitywithinhours24 + @Xrayfacilitywithinhours48
    @xraytransmissionpercentagetotal = @xraytransmissionpercentage / 2

    @doctoraccuracycertified = Transaction.joins("join transaction_result_updates on transaction_result_updates.transaction_id=transactions.id").joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null").group("doctors.name").count
    @xrayqualitycompliance = Transaction.joins(:xray_review).joins(:xray_facility).where("xray_reviews.transmitted_at is not null and transactions.status not IN('CANCELLED') and transactions.xray_film_type IN ('DIGITAL')").group("xray_facilities.code").count
    # filter
    if request.format.js? && params[:value].nil?
      @filters = JSON.parse(params.keys.first)
      @filters = convert_values_to_arrays(@filters)
      # calling filter from here
      @filtervalues = apply_filter(@filters)
    end

  end

  def apply_filter(filter_params)
    @filtervalues = Doctor.all
    @current_year = Date.today.year
    filter_params.each do |param_key, param_value|
      case param_key
      when "DateRange"
        if param_value.present?
          start_date, end_date = param_value.split(" - ")
          @doctorsactive = Doctor.where('doctors.status=? and created_at>=? and created_at<=?', 'ACTIVE', start_date, end_date).count
          @doctornew = Doctor.where("created_at>=? and created_at<=?", start_date, end_date).count
          @doctorwithdrawl = Doctor.joins(:status_schedule).where("doctors.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?", 'INACTIVE', ["01", "02"], start_date, end_date).count
          @doctordemised = Doctor.joins(:status_schedule).where('doctors.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', '07', start_date, end_date).count
          @doctornoncomp = Doctor.joins(:status_schedule).where('doctors.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["06", "03"], start_date, end_date).count
          @doctorstates = Doctor.joins(:state).where('doctors.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).group('states.name').count

          @doctorquotausagezero = Doctor.where('quota_used=? and doctors.created_at>=? and doctors.created_at<=?', 0, start_date, end_date).count
          @doctorquotausage1to100 = Doctor.where('quota_used>0 and quota_used<=100 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage101to200 = Doctor.where('quota_used>101 and quota_used<=200 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage201to300 = Doctor.where('quota_used>201 and quota_used<=300 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage301to400 = Doctor.where('quota_used>301 and quota_used<=400 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage401to500 = Doctor.where('quota_used>401 and quota_used<=500 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage501to600 = Doctor.where('quota_used>501 and quota_used<=600 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage601to700 = Doctor.where('quota_used>601 and quota_used<=700 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count
          @doctorquotausage701to800 = Doctor.where('quota_used>701 and quota_used<=800 and doctors.created_at>=? and doctors.created_at<=?', start_date, end_date).count

          @xrayfacilityactive = XrayFacility.where('xray_facilities.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).count
          @xrayfacilitynew = XrayFacility.where("doctors.created_at>=? and doctors.created_at<=?", start_date, end_date).count
          @xrayfacilitywithdrawl = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and  status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["01", "02"], start_date, end_date).count
          @xrayfacilitydemised = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', '07', start_date, end_date).count
          @xrayfacilitynoncomp = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["06", "03"], start_date, end_date).count
          @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).group('states.name').count

          @laboratoriesactive = Laboratory.where('laboratories.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).count
          @laboratoriesnew = Laboratory.where("doctors.created_at>=? and doctors.created_at<=?", start_date, end_date).count
          @laboratorywithdrawl = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["01", "02"], start_date, end_date).count
          @laboratorydemised = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', '07', start_date, end_date).count
          @laboratorynoncomp = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["06", "03"], start_date, end_date).count
          @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).group('states.name').count

          @radiologistactive = Radiologist.where('radiologists.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).count
          @radiologistnew = Radiologist.where("doctors.created_at>=? and doctors.created_at<=?", start_date, end_date).count
          @radiologistwithdrawl = Radiologist.joins(:status_schedule).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["01", "02"], start_date, end_date).count
          @radiologistdemised = Radiologist.joins(:status_schedule).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', '07', start_date, end_date).count
          @radiologistnoncomp = Radiologist.joins(:status_schedule).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.from>=? and status_schedules.from<=?', 'INACTIVE', ["06", "03"], start_date, end_date).count
          @radiologiststates = Radiologist.joins(:state).where('radiologists.status=? and doctors.created_at>=? and doctors.created_at<=?', 'ACTIVE', start_date, end_date).group('states.name').count
        end
      when "doctor"
        if param_value.present?
          @doctorsactive = Doctor.where('status=? and code=?', 'ACTIVE', param_value).count
          @current_year = Date.today.year
          @doctornew = Doctor.where("extract(year from created_at) = ? and code=?", @current_year, param_value).count
          @doctorwithdrawl = Doctor.joins(:status_schedule).where("doctors.status=? and status_schedules.status_reason IN(?) and code=?", 'INACTIVE', ["01", "02"], param_value).count
          @doctordemised = Doctor.joins(:status_schedule).where('doctors.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', '07', param_value).count
          @doctornoncomp = Doctor.joins(:status_schedule).where('doctors.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', ["06", "03"], param_value).count
          @doctorstates = Doctor.joins(:state).where('doctors.status=? and doctors.code=?', 'ACTIVE', param_value).group('states.name').count

          @doctorquotausagezero = Doctor.where('quota_used=? and code=?', 0, param_value).count
          @doctorquotausage1to100 = Doctor.where('quota_used>0 and quota_used<=100 and code=?', param_value).count
          @doctorquotausage101to200 = Doctor.where('quota_used>101 and quota_used<=200 and code=?', param_value).count
          @doctorquotausage201to300 = Doctor.where('quota_used>201 and quota_used<=300 and code=?', param_value).count
          @doctorquotausage301to400 = Doctor.where('quota_used>301 and quota_used<=400 and code=?', param_value).count
          @doctorquotausage401to500 = Doctor.where('quota_used>401 and quota_used<=500 and code=?', param_value).count
          @doctorquotausage501to600 = Doctor.where('quota_used>501 and quota_used<=600 and code=?', param_value).count
          @doctorquotausage601to700 = Doctor.where('quota_used>601 and quota_used<=700 and code=?', param_value).count
          @doctorquotausage701to800 = Doctor.where('quota_used>701 and quota_used<=800 and code=?', param_value).count

          @certifydoctoroverallcount = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null ").count
          @certifydoctorxrayyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and doctors.code=?", param_value).count
          @certifydoctorlabyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and doctors.code=?", param_value).count

          @certifydoctorxrayno = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) > 1 and doctors.code=?", param_value).count
          @certifydoctorlabno = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) > 1 and doctors.code=?", param_value).count

          @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes
          @certifydoctorbeyond24hours = @certifydoctorxrayno + @certifydoctorlabno
          if (@certifydoctoroverallcount != nil)
            @ceritifydoctorperyestotal = (@certifydoctorwithin24hours)
            if (@certifydoctorbeyond24hours * 100 / @certifydoctoroverallcount < 15)
              @ceritifydoctorperyestotal = @ceritifydoctorperyestotal + 1
            else
              @ceritifydoctorperyestotal = @ceritifydoctorperyestotal + 0
            end
          else
            @ceritifydoctorperyestotal = 0
            @ceritifydoctorpernototal = 0
          end
          @doctoraccuracycertified = Transaction.joins(:transaction_result_update).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null and doctors.code IN(?)", param_value).group("doctors.name").count
          @doctoraccuracywrongtransmission = Transaction.joins(:transaction_result_update).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transaction_result_updates.wrong_transmission_doctor='TRUE' and doctors.code IN(?)", param_value).group("doctors.name").count
          @doctoraccuracytransmissiontotal = @doctoraccuracycertified.count - @doctoraccuracywrongtransmission.count
        end
      when 'xray'
        if param_value.present?
          @xrayfacilityactive = XrayFacility.where('status=? and code=?', 'ACTIVE', param_value).count
          @xrayfacilitynew = XrayFacility.where("extract(year from created_at) = ? and code=?", @current_year, param_value).count
          @xrayfacilitywithdrawl = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', ["01", "02"], param_value).count
          @xrayfacilitydemised = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', '07', param_value).count
          @xrayfacilitynoncomp = XrayFacility.joins(:status_schedule).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', ["06", "03"], param_value).count
          @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=? and xray_facilities.code=?', 'ACTIVE', param_value).group('states.name').count

          @Xrayfacilitywithinhours24 = Transaction.joins(:xray_facility).joins(:xray_examination).where("xray_facilities.radiologist_operated='TRUE' and transactions.radiologist_id is null and xray_facilities.radiologist_operated='FALSE' and xray_examinations.xray_taken_date is not null and transactions.status not IN('CANCELLED','REJECTED') and DATE_PART('Day',transmitted_at - xray_taken_date) < 1 and xray_facilities.code IN(?)", param_value).count
          @Xrayfacilitywithinhours48 = Transaction.joins(:xray_facility).joins(:xray_examination).where("xray_facilities.radiologist_operated='TRUE' and transactions.radiologist_id is not null and xray_facilities.radiologist_operated='FALSE' and xray_examinations.xray_taken_date is not null and transactions.status not IN('CANCELLED','REJECTED') and DATE_PART('Day',transmitted_at - xray_taken_date) < 2 and xray_facilities.code IN(?)", param_value).count
          @xraytransmissionpercentage = @Xrayfacilitywithinhours24 + @Xrayfacilitywithinhours48
          @xraytransmissionpercentagetotal = @xraytransmissionpercentage / 2
          @xrayqualitycompliance = Transaction.joins(:xray_review).joins(:xray_facility).where("xray_reviews.transmitted_at is not null and transactions.status not IN('CANCELLED') and transactions.xray_film_type IN ('DIGITAL') and xray_facilities.code IN(?)", param_value).group("xray_facilities.code").count
        end
      when 'lab'
        if param_value.present?
          @laboratoriesactive = Laboratory.where('status=? and code=?', 'ACTIVE', param_value).count
          @laboratoriesnew = Laboratory.where("extract(year from created_at) = ? and code=?", @current_year, param_value).count
          @laboratorywithdrawl = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', ["01", "02"], param_value).count
          @laboratorydemised = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', '07', param_value).count
          @laboratorynoncomp = Laboratory.joins(:status_schedule).where('laboratories.status=? and status_schedules.status_reason IN(?) and code=?', 'INACTIVE', ["06", "03"], param_value).count
          @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=? and laboratories.code=?', 'ACTIVE', param_value).group('states.name').count
          @laboratorydonutwithin48 = Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) < 2 and laboratories.code IN(?) ", param_value).count
          @laboratorydonutbeyond48 = Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) > 2 and laboratories.code IN(?)", param_value).count
        end
      end
    end
    @filtervalues

  end

  def convert_values_to_arrays(hash)
    converted_hash = {}
    hash.each_with_index do |(key, value), index|
      if index == 0
        converted_hash[key] = value
      else
        converted_hash[key] = value.split(',')
      end
    end
    converted_hash
  end

  def calculate_grades(filter_params)
    ceritifydoctorperyestotal = filter_params[:ceritifydoctorperyestotal] || 0
    doctoraccuracytransmissiontotal = filter_params[:doctoraccuracytransmissiontotal] || 0
    xraytransmissionpercentagetotal = filter_params[:xraytransmissionpercentagetotal] || 0
    xrayqualitycompliance = filter_params[:xrayqualitycompliance] || 0
    laboratorydonutwithin48 = filter_params[:laboratorydonutwithin48] || 0
    laboratorydonutbeyond48 = filter_params[:laboratorydonutbeyond48] || 0

    doctor_performance_total = (ceritifydoctorperyestotal + doctoraccuracytransmissiontotal)
    doctor_performance_percentage = (doctor_performance_total.to_f / 200) * 100
    @doctor_grade = calculate_grade(doctor_performance_percentage)

    xray_performance_total = (xraytransmissionpercentagetotal + xrayqualitycompliance)
    xray_performance_percentage = (xray_performance_total.to_f / 200) * 100
    @xray_grade = calculate_grade(xray_performance_percentage)
    laboratory_performance_total = (laboratorydonutwithin48 + laboratorydonutbeyond48)
    laboratory_performance_percentage = (laboratory_performance_total.to_f / 200) * 100
    @laboratory_grade = calculate_grade(laboratory_performance_percentage)

  end

  def calculate_grade(value)
    case value
    when 80..100
      'A'
    when 70..79
      'B'
    when 60..69
      'C'
    when 50..59
      'D'
    when 0..49
      'E'
    else
      'NA'
    end
  end

end