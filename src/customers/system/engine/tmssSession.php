<?php

/*
    Use the static method getInstance to get the object.
*/

final class tmssSession
{
    const SESSION_STARTED = TRUE;
    const SESSION_NOT_STARTED = FALSE;
    
    // The state of the session
    private $sessionState = self::SESSION_NOT_STARTED;
    
    // THE only instance of the class
    private static $instance;
    
    
    function __construct() {}
    
    
    /**
    *    Returns THE instance of 'Session'.
    *    The session is automatically initialized if it wasn't.
    *    
    *    @return    object
    **/
    
    public static function getInstance()
    {
        if ( !isset(self::$instance))
        {
            self::$instance = new self;
        }
        
        self::$instance->startSession();
        
        return self::$instance;
    }
    
    
    /**
    *    (Re)starts the session.
    *    
    *    @return    bool    TRUE if the session has been initialized, else FALSE.
    **/
    
    public function startSession()
    {
        if ( $this->sessionState == self::SESSION_NOT_STARTED )
        {
            $this->sessionState = session_start();
        }
        
        return $this->sessionState;
    }
    
    
    /**
    *    Stores datas in the session.
    *    Example: $instance->foo = 'bar';
    *    
    *    @param    name    Name of the datas.
    *    @param    value    Your datas.
    *    @return    void
    **/
    
    public function __set( $lp_key , $lp_val ) {
			if ( empty($lp_val) ) {
				$_SESSION[$lp_key] = $lp_val;
			} else {
				$_SESSION[$lp_key] = $lp_val; 
			}
    }
		public function set( $lp_key, $lp_val ) {
			if ( empty($lp_val) ) {
				unset( $_SESSION[$lp_key] );
			} else {
				$_SESSION[$lp_key] = $lp_val; 
			}
		}
    
    
    /**
    *    Gets datas from the session.
    *    Example: echo $instance->foo;
    *    
    *    @param    name    Name of the datas to get.
    *    @return    mixed    Datas stored in session.
    **/
    public function __get( $lp_key ) {
			if ( isset($_SESSION[$lp_key])) {
        return $_SESSION[$lp_key];
			}
		}
		public function get( $lp_key ) {
			if ( isset($_SESSION[$lp_key])) {
        return $_SESSION[$lp_key];
			}
		}
    
    
    public function __isset( $name ) {
      return isset($_SESSION[$name]);
    }
    
    
    public function __unset( $name ) {
      unset( $_SESSION[$name] );
    }
    
    
    /**
    *    Destroys the current session.
    *    
    *    @return    bool    TRUE is session has been deleted, else FALSE.
    **/
    
    public function destroy()
    {
        if ( $this->sessionState == self::SESSION_STARTED )
        {
            $this->sessionState = !session_destroy();
            unset( $_SESSION );
            
            return !$this->sessionState;
        }
        
        return FALSE;
    }
}

?>