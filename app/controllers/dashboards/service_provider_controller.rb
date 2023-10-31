class Dashboards::ServiceProviderController < ApplicationController
	def index
		@doctorsactive=Doctor.where(status:'ACTIVE').count
		@laboratoriesactive=Laboratory.where(status:'ACTIVE').count
        @xrayfacilityactive=XrayFacility.where(status:'ACTIVE').count
        @radiologistactive=Radiologist.where(status:'ACTIVE').count
        @current_year = Date.today.year
        @doctornew=Doctor.where("extract(year from created_at) = ?",@current_year).count
        @laboratoriesnew=Laboratory.where("extract(year from created_at) = ?",@current_year).count
        @xrayfacilitynew=XrayFacility.where("extract(year from created_at) = ?",@current_year).count
        @radiologistnew=Radiologist.where("extract(year from created_at) = ?",@current_year).count

 
        @doctorwithdrawl=Doctor.where("status=? and status_reason IN(?)",'INACTIVE',["01","02"]).count
        @laboratorywithdrawl=Laboratory.where('status=? and status_reason IN(?)','INACTIVE',["01","02"]).count
        @xrayfacilitywithdrawl=XrayFacility.where('status=? and status_reason IN(?)','INACTIVE',["01","02"]).count
	    @radiologistwithdrawl=Radiologist.where('status=? and status_reason IN(?)','INACTIVE',["01","02"]).count

	    @doctordemised=Doctor.where('status=? and status_reason IN(?)','INACTIVE','07').count
        @laboratorydemised=Laboratory.where('status=? and status_reason IN(?)','INACTIVE','07').count
        @xrayfacilitydemised=XrayFacility.where('status=? and status_reason IN(?)','INACTIVE','07').count
        @radiologistdemised=Radiologist.where('status=? and status_reason IN(?)','INACTIVE','07').count


        @doctornoncomp=Doctor.where('status=? and status_reason IN(?)','INACTIVE',["06","03"]).count
        @laboratorynoncomp=Laboratory.where('status=? and status_reason IN(?)','INACTIVE',["06","03"]).count
        @xrayfacilitynoncomp=XrayFacility.where('status=? and status_reason IN(?)','INACTIVE',["06","03"]).count
        @radiologistnoncomp=Radiologist.where('status=? and status_reason IN(?)','INACTIVE',["06","03"]).count
        
        @doctorstates=Doctor.joins(:state).where('doctors.status=?','ACTIVE').group('states.name').count
        @laboratoriesstates=Laboratory.joins(:state).where('laboratories.status=?','ACTIVE').group('states.name').count        
        @xrayfacilitiesstates=XrayFacility.joins(:state).where('xray_facilities.status=?','ACTIVE').group('states.name').count
        @radiologiststates=Radiologist.joins(:state).where('radiologists.status=?','ACTIVE').group('states.name').count

        @doctorquotausagezero=Doctor.where('quota_used=?',0).count        
        @doctorquotausage1to100=Doctor.where('quota_used>0 and quota_used<=100').count        
        @doctorquotausage101to200=Doctor.where('quota_used>101 and quota_used<=200').count            
        @doctorquotausage201to300=Doctor.where('quota_used>201 and quota_used<=300').count                    
        @doctorquotausage301to400=Doctor.where('quota_used>301 and quota_used<=400').count                            
        @doctorquotausage401to500=Doctor.where('quota_used>401 and quota_used<=500').count                            
        @doctorquotausage501to600=Doctor.where('quota_used>501 and quota_used<=600').count  
        @doctorquotausage601to700=Doctor.where('quota_used>601 and quota_used<=700').count  
        @doctorquotausage701to800=Doctor.where('quota_used>701 and quota_used<=800').count  
       
        @certifydoctoroverallcount=Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").count
        @certifydoctorxrayyes=Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date  and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and extract(year from transactions.created_at) = ?",@current_year).count
        @certifydoctorlabyes=Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and extract(year from transactions.created_at) = ?",@current_year).count
         
        @certifydoctorxrayno=Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) > 1 and extract(year from transactions.created_at) = ?",@current_year).count
        @certifydoctorlabno=Transaction.joins(:doctor).group(:doctor_id).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) > 1 and extract(year from transactions.created_at) = ?",@current_year).count
         
        @certifydoctorwithin24hours=(@certifydoctorxrayyes.count)+(@certifydoctorlabyes.count)
        @certifydoctorbeyond24hours=@certifydoctorxrayno.count+@certifydoctorlabno.count
        
        if(@certifydoctoroverallcount!=nil)
	        @ceritifydoctorperyestotal=(@certifydoctorwithin24hours)
	        if(@certifydoctorbeyond24hours*100/@certifydoctoroverallcount.count<15)
	          @ceritifydoctorperyestotal=@ceritifydoctorperyestotal+1
	        else
	          @ceritifydoctorperyestotal=@ceritifydoctorperyestotal+0
            end
        else
    	    @ceritifydoctorperyestotal=0
    	    @ceritifydoctorpernototal=0

        end
        
        @laboratorydonutwithin48=Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) < 2 and extract(year from transactions.created_at) = ?",@current_year).count
        @laboratorydonutbeyond48=Transaction.joins(:laboratory_examination).where("transactions.status not in ('CANCELLED','REJECTED') and specimen_taken_date is not null and  DATE_PART('Day',laboratory_transmit_date - specimen_taken_date) > 2 and extract(year from transactions.created_at) = ?",@current_year).count
        
       @Xrayfacilitywithinhours24=Transaction.joins(:xray_facility).select("CASE WHEN xray_facilities.radiologist_operated ='TRUE' and transactions.radiologist_id is null then 1 end").count
       #filter
     if request.format.js? && params[:value].nil?
      @filters = JSON.parse(params.keys.first)
      @filters = convert_values_to_arrays(@filters)
      
      #calling filter from here 
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

        @doctorsactive=Doctor.where('status=? and created_at>=? and created_at<=?','ACTIVE',start_date,end_date).count
      
        @doctornew=Doctor.where("created_at>=? and created_at<=?",start_date,end_date).count
        @doctorwithdrawl=Doctor.where("status=? and status_reason IN(?) and created_at>=? and created_at<=?",'INACTIVE',["01","02"],start_date,end_date).count
        @doctordemised=Doctor.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE','07',start_date,end_date).count
        @doctornoncomp=Doctor.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["06","03"],start_date,end_date).count

        @doctorstates=Doctor.joins(:state).where('doctors.status=? and doctors.created_at>=? and doctors.created_at<=?','ACTIVE',start_date,end_date).group('states.name').count

        @doctorquotausagezero=Doctor.where('quota_used=? and created_at>=? and created_at<=?',0,start_date,end_date).count        
        @doctorquotausage1to100=Doctor.where('quota_used>0 and quota_used<=100 and created_at>=? and created_at<=?',start_date,end_date).count        
        @doctorquotausage101to200=Doctor.where('quota_used>101 and quota_used<=200 and created_at>=? and created_at<=?',start_date,end_date).count            
        @doctorquotausage201to300=Doctor.where('quota_used>201 and quota_used<=300 and created_at>=? and created_at<=?',start_date,end_date).count                    
        @doctorquotausage301to400=Doctor.where('quota_used>301 and quota_used<=400 and created_at>=? and created_at<=?',start_date,end_date).count                            
        @doctorquotausage401to500=Doctor.where('quota_used>401 and quota_used<=500 and created_at>=? and created_at<=?',start_date,end_date).count                            
        @doctorquotausage501to600=Doctor.where('quota_used>501 and quota_used<=600 and created_at>=? and created_at<=?',start_date,end_date).count  
        @doctorquotausage601to700=Doctor.where('quota_used>601 and quota_used<=700 and created_at>=? and created_at<=?',start_date,end_date).count  
        @doctorquotausage701to800=Doctor.where('quota_used>701 and quota_used<=800 and created_at>=? and created_at<=?',start_date,end_date).count  

        @xrayfacilityactive=XrayFacility.where('status=? and created_at>=? and created_at<=?','ACTIVE',start_date,end_date).count     
        @xrayfacilitynew=XrayFacility.where("created_at>=? and created_at<=?",start_date,end_date).count
        @xrayfacilitywithdrawl=XrayFacility.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["01","02"],start_date,end_date).count        
        @xrayfacilitydemised=XrayFacility.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE','07',start_date,end_date).count
        @xrayfacilitynoncomp=XrayFacility.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["06","03"],start_date,end_date).count                   
        @xrayfacilitiesstates=XrayFacility.joins(:state).where('xray_facilities.status=? and xray_facilities.created_at>=? and xray_facilities.created_at<=?','ACTIVE',start_date,end_date).group('states.name').count

        @laboratoriesactive=Laboratory.where('status=? and created_at>=? and created_at<=?','ACTIVE',start_date,end_date).count
        @laboratoriesnew=Laboratory.where("created_at>=? and created_at<=?",start_date,end_date).count
        @laboratorywithdrawl=Laboratory.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["01","02"],start_date,end_date).count
        @laboratorydemised=Laboratory.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE','07',start_date,end_date).count
        @laboratorynoncomp=Laboratory.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["06","03"],start_date,end_date).count
        @laboratoriesstates=Laboratory.joins(:state).where('laboratories.status=? and laboratories.created_at>=? and laboratories.created_at<=?','ACTIVE',start_date,end_date).group('states.name').count 

        @radiologistactive=Radiologist.where('status=? and created_at>=? and created_at<=?','ACTIVE',start_date,end_date).count
        @radiologistnew=Radiologist.where("created_at>=? and created_at<=?",start_date,end_date).count
        @radiologistwithdrawl=Radiologist.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["01","02"],start_date,end_date).count
        @radiologistdemised=Radiologist.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE','07',start_date,end_date).count
        @radiologistnoncomp=Radiologist.where('status=? and status_reason IN(?) and created_at>=? and created_at<=?','INACTIVE',["06","03"],start_date,end_date).count
        @radiologiststates=Radiologist.joins(:state).where('radiologists.status=? and radiologists.created_at>=? and radiologists.created_at<=?','ACTIVE',start_date,end_date).group('states.name').count

        end   
      when "doctor"
      	   if param_value.present?
      	@doctorsactive=Doctor.where('status=? and code=?','ACTIVE',param_value).count
      	@current_year = Date.today.year
        @doctornew=Doctor.where("extract(year from created_at) = ? and code=?",@current_year,param_value).count
        @doctorwithdrawl=Doctor.where("status=? and status_reason IN(?) and code=?",'INACTIVE',["01","02"],param_value).count
        @doctordemised=Doctor.where('status=? and status_reason IN(?) and code=?','INACTIVE','07',param_value).count
        @doctornoncomp=Doctor.where('status=? and status_reason IN(?) and code=?','INACTIVE',["06","03"],param_value).count

        @doctorstates=Doctor.joins(:state).where('doctors.status=? and doctors.code=?','ACTIVE',param_value).group('states.name').count

        @doctorquotausagezero=Doctor.where('quota_used=? and code=?',0,param_value).count        
        @doctorquotausage1to100=Doctor.where('quota_used>0 and quota_used<=100 and code=?',param_value).count        
        @doctorquotausage101to200=Doctor.where('quota_used>101 and quota_used<=200 and code=?',param_value).count            
        @doctorquotausage201to300=Doctor.where('quota_used>201 and quota_used<=300 and code=?',param_value).count                    
        @doctorquotausage301to400=Doctor.where('quota_used>301 and quota_used<=400 and code=?',param_value).count                            
        @doctorquotausage401to500=Doctor.where('quota_used>401 and quota_used<=500 and code=?',param_value).count                            
        @doctorquotausage501to600=Doctor.where('quota_used>501 and quota_used<=600 and code=?',param_value).count  
        @doctorquotausage601to700=Doctor.where('quota_used>601 and quota_used<=700 and code=?',param_value).count  
        @doctorquotausage701to800=Doctor.where('quota_used>701 and quota_used<=800 and code=?',param_value).count  

         
        @certifydoctoroverallcount=Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null ").count
        @certifydoctorxrayyes=Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and doctors.code=?",param_value).count
        @certifydoctorlabyes=Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and doctors.code=?",param_value).count
         
        @certifydoctorxrayno=Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) > 1 and doctors.code=?",param_value).count
        @certifydoctorlabno=Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) > 1 and doctors.code=?",param_value).count
         
        @certifydoctorwithin24hours=@certifydoctorxrayyes+@certifydoctorlabyes
        @certifydoctorbeyond24hours=@certifydoctorxrayno+@certifydoctorlabno
       end
      when 'xray'
      if param_value.present?
        @xrayfacilityactive=XrayFacility.where('status=? and code=?','ACTIVE',param_value).count     
        @xrayfacilitynew=XrayFacility.where("extract(year from created_at) = ? and code=?",@current_year,param_value).count
        @xrayfacilitywithdrawl=XrayFacility.where('status=? and status_reason IN(?) and code=?','INACTIVE',["01","02"],param_value).count        
        @xrayfacilitydemised=XrayFacility.where('status=? and status_reason IN(?) and code=?','INACTIVE','07',param_value).count
        @xrayfacilitynoncomp=XrayFacility.where('status=? and status_reason IN(?) and code=?','INACTIVE',["06","03"],param_value).count                   
        @xrayfacilitiesstates=XrayFacility.joins(:state).where('xray_facilities.status=? and xray_facilities.code=?','ACTIVE',param_value).group('states.name').count
      end

      when 'lab'
      if param_value.present?
        @laboratoriesactive=Laboratory.where('status=? and code=?','ACTIVE',param_value).count
        @laboratoriesnew=Laboratory.where("extract(year from created_at) = ? and code=?",@current_year,param_value).count
        @laboratorywithdrawl=Laboratory.where('status=? and status_reason IN(?) and code=?','INACTIVE',["01","02"],param_value).count
        @laboratorydemised=Laboratory.where('status=? and status_reason IN(?) and code=?','INACTIVE','07',param_value).count
        @laboratorynoncomp=Laboratory.where('status=? and status_reason IN(?) and code=?','INACTIVE',["06","03"],param_value).count
        @laboratoriesstates=Laboratory.joins(:state).where('laboratories.status=? and laboratories.code=?','ACTIVE',param_value).group('states.name').count 
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
end
