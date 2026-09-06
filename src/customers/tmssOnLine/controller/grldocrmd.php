<?php
final class grldocrmdController extends tmssController {
  
	const CONTROLLER = 'grldocrmd';			// **************************
	const MODEL = 'grldocrmd';					// **************************
	const VIEW  = 'grldocrmd';					// **************************
	const ID = 'docrmdcod';							// **************************
	const OBJTYP ='GRL_RMD';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE
      case '#00':
        if ( $this->lo_mdl->save() ) {
					return $this->getView();
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        } 
        break;
			
			
			// NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->getView();
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																										
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																			// ********************
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );										// ********************
				}
				$lv_key['curdte'] = $lp_prm['curdte'];

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro ['.self::ID.'].</errtxt>';

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';

				} else if ( $lp_act=='#001' ) {
					$this->lo_mdl->docrmdcod = '';																									// ********************
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				$this->lo_mdl->curdte = $lp_prm['curdte'];
				$this->lo_mdl->docrmdstrtme = date_format($this->lo_mdl->docrmdstrtme,'H:i');

				return $this->getView();
        break;
			
			
			// DELETE
      case '#04':
				$lo_dat = $this->co_reg->request->post;
				$lo_dat['docrmdstrtme'] = '';
        if ( $this->lo_mdl->delete($lo_dat) ) {
					return '<errcod></errcod><errtxt></errtxt>';
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        }
        break;
			
			
			// CHECK REMINDER
      case '#10':
				$lo_dat = $this->co_reg->request->post;
				$lo_dat['docrmdstrdte'] = $lp_prm['curdte'];
        if ( $this->lo_mdl->checkReminder($lo_dat) ) {
					return '<errcod></errcod><errtxt></errtxt><docrmdlogcod>'.$this->lo_mdl->docrmdlogcod.'</docrmdlogcod>';
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt><docrmdlogcod></docrmdlogcod>';
        }
        break;
				
				
			// UNCHECK REMINDER
      case '#11':
				$lo_dat = $this->co_reg->request->post;
				$lo_dat['docrmdstrdte'] = $lp_prm['curdte'];
        if ( $this->lo_mdl->uncheckReminder($lo_dat) ) {
					return '<errcod></errcod><errtxt></errtxt><docrmdlogcod>'.$this->lo_mdl->docrmdlogcod.'</docrmdlogcod>';
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt><docrmdlogcod></docrmdlogcod>';
        }
        break;				
			
			
			// GET REMINDERS LIST
			case '#18':
				$lv_strdte = $this->co_reg->request->post['start'];
				$lv_enddte = $this->co_reg->request->post['end'];
        $lv_prm = array('docrmdstrdte' =>$lv_strdte, 'docrmdenddte' =>$lv_enddte );

        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]r.docrmdstrdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
                        							'[~fltrow~]r.cteusr'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																			);
        
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
        
			  //$lo_rs = $this->lo_mdl->getRemindersOfPeriod( array(), $lv_prm );
        
				$lo_data = array();
        foreach( $lo_rs as $lv_row ) {
					$lo_data[] = array( 'start'=>date_format($lv_row['docrmdstrtme'],'c'), 
															'title'=>$lv_row['docrmdtxt'], 
															'url'=>'?prg=grldocrmd&act=03&prm_docrmdcod='.$lv_row['docrmdcod'].'&prm_curdte='.date_format($lv_row['docrmdstrtme'],'d/m/Y'),
															'docrmdcod'=>$lv_row['docrmdcod'],
															'docrmdtxt'=>$lv_row['docrmdtxt'],
															'docrmdstrtme'=>date_format($lv_row['docrmdstrtme'],'H:i'),
                              'docrmdlogcod'=>(isset($lv_row['docrmdlogcod']) ? $lv_row['docrmdlogcod']:''),
															'color'=>(isset($lv_row['docrmdlogcod'])?'#c6c6c6':''));
				}
				return $this->co_reg->document->getJson( $lo_data );
				break;
			
			
			// GET REMINDERS CALENDAR
      case '#19':
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'data' => $this->lo_mdl,
												'doc'=> $this->co_reg->document,
												'objtyp' => self::OBJTYP,
												'actcod' => $this->data['actcod'],
												'model' => self::MODEL
												);
				$lv_ret = $this->co_reg->load->view( 'grldocrmdcal', $lv_prm );
				return $lv_ret;
        break;

    }

  }
	
	
	/**
	 * getView
	 * send screen to client browser
	 */
	private function getView() {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' => $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data' => $this->lo_mdl,
										'doc'=> $this->co_reg->document,
										'objtyp' => self::OBJTYP,
										'actcod' => $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
}
?>