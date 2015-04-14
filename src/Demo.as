package
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   import flash.system.Capabilities;
   import flash.utils.getTimer;
   
   import com.tapirgames.gesture.GestureAnalyzer;
   import com.tapirgames.gesture.GesturePoint;
   import com.tapirgames.gesture.GestureSegment;
   
   public class Demo extends Sprite
   {
      [Embed("0.png")]
      public static const IconLine:Class;
      [Embed("1.png")]
      public static const IconLineArrow:Class;
      [Embed("2.png")]
      public static const IconLineZigzag:Class;
      [Embed("3.png")]
      public static const IconArrow:Class;
      [Embed("4.png")]
      public static const IconPool:Class;
      [Embed("5.png")]
      public static const IconWave:Class;
      [Embed("6.png")]
      public static const IconZigzag:Class;
      [Embed("6b.png")]
      public static const IconMirrorZigzag:Class;
      [Embed("7.png")]
      public static const IconCircle:Class;
      [Embed("8.png")]
      public static const IconTriangle:Class;
      [Embed("9.png")]
      public static const IconFivePointStar:Class;
      
      public static const IconSize:Number = 50;
      
      public function Demo ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         
         mBackground = new Sprite ();
         addChild (mBackground);
         
         mPointLayer = new Sprite ();
         addChild (mPointLayer);
         
         mLineLayer = new Sprite ();
         addChild (mLineLayer);
         
         mTextField = new TextField ();
         mTextField.autoSize = TextFieldAutoSize.CENTER;
         mTextField.background = false;
         mTextField.border = false;

         var format:TextFormat = new TextFormat();
         format.font = "Verdana";
         format.color = 0xFF0000;
         format.size = 10;
         format.underline = false;

         mTextField.defaultTextFormat = format;
         addChild (mTextField);
         
         SetText ("Please draw above gesture in any rotation.");
         
         addChild (mRecognizeResult);
         mRecognizeResult.visible = false;
         
         var x:Number = 0;
         mLineIcon = new IconLine (); addChild (mLineIcon); mLineIcon.x = x; x += IconSize;
         mLineArrowIcon = new IconLineArrow (); addChild (mLineArrowIcon); mLineArrowIcon.x = x; x += IconSize;
         mLineZigzagIcon = new IconLineZigzag (); addChild (mLineZigzagIcon); mLineZigzagIcon.x = x; x += IconSize;
         mArrowIcon = new IconArrow (); addChild (mArrowIcon); mArrowIcon.x = x; x += IconSize;
         mPoolIcon = new IconPool (); addChild (mPoolIcon); mPoolIcon.x = x; x += IconSize;
         mWaveIcon = new IconWave (); addChild (mWaveIcon); mWaveIcon.x = x; x += IconSize;
         mZigzagIcon = new IconZigzag (); addChild (mZigzagIcon); mZigzagIcon.x = x; x += IconSize;
         mCircleIcon = new IconCircle (); addChild (mCircleIcon); mCircleIcon.x = x; x += IconSize;
         mTriangleIcon = new IconTriangle (); addChild (mTriangleIcon); mTriangleIcon.x = x; x += IconSize;
         mFivePointStarIcon = new IconFivePointStar (); addChild (mFivePointStarIcon); mFivePointStarIcon.x = x; x += IconSize;
      }
      
      private var mBackground:Sprite;
      
      private var mPointLayer:Sprite;
      private var mLineLayer:Sprite;
      
      private var mTextField:TextField;
      
      private var mLineIcon:Bitmap = new IconLine ();
      private var mLineArrowIcon:Bitmap = new IconLineArrow ();
      private var mLineZigzagIcon:Bitmap = new IconLineZigzag ();
      private var mArrowIcon:Bitmap = new IconArrow ();
      private var mPoolIcon:Bitmap = new IconPool ();
      private var mWaveIcon:Bitmap = new IconWave ();
      private var mZigzagIcon:Bitmap = new IconZigzag ();
      private var mCircleIcon:Bitmap = new IconCircle ();
      private var mTriangleIcon:Bitmap = new IconTriangle ();
      private var mFivePointStarIcon:Bitmap = new IconFivePointStar ();
      
      private var mRecognizeResult:Sprite = new Sprite ();
      
      public function SetText (text:String):void
      {
         mTextField.text = text;
      }
      
      public function SetRecognizeResult (resultBitmap:Bitmap, angle:Number = 0):void
      {
         while (mRecognizeResult.numChildren > 0)
            mRecognizeResult.removeChildAt (0);
         
         if (resultBitmap != null)
         {
            resultBitmap.x -= 0.5 * IconSize;
            resultBitmap.y -= 0.5 * IconSize;
            mRecognizeResult.addChild (resultBitmap);
            mRecognizeResult.rotation = angle;
            mRecognizeResult.visible = true;
         }
         else
         {
            mRecognizeResult.visible = false;
         }
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         //stage.quality = StageQuality.HIGH;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.frameRate = 60;
         
         mBackground.graphics.beginFill(0xffffff);
         mBackground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
         mBackground.graphics.endFill();
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         stage.addEventListener (Event.RESIZE, OnResize);
         
         OnResize ();
      }

      private function OnResize (event:Event = null):void
      {
         if (stage != null)
         {
            var rect:Rectangle = mTextField.getBounds (mTextField);
            mTextField.x = 0.5 * (stage.stageWidth - rect.width);
            mTextField.y = 0.5 * (stage.stageHeight - rect.height) + 150;
            
            mRecognizeResult.x = 0.5 * stage.stageWidth;
            mRecognizeResult.y = 0.5 * stage.stageHeight;
         }
      }
      
      private var mGestureAnalyzer:GestureAnalyzer = null;
      
      private function OnMouseDown (event:MouseEvent):void
      {
         mLineLayer.graphics.clear ();
         mPointLayer.graphics.clear ();
         
         if (mGestureAnalyzer == null)
            mGestureAnalyzer = new GestureAnalyzer (Capabilities.screenDPI * 0.2, Capabilities.screenDPI * 0.02);
         
         RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY);
      }
      
      private function OnMouseMove (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            if (event.buttonDown)
            {
               RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY);
            }
            else
            {
               mGestureAnalyzer = null;
            }
         }
      }
      
      private function OnMouseUp (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            //RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY); // the release point is often a bad point
            
            mGestureAnalyzer.Finish (getTimer ());
            var result:Object = mGestureAnalyzer.Analyze ();
            
            if (result.mGestureType == null)
            {
               SetText ("Too weird to recognize.");
               SetRecognizeResult (null);
               return;
            }
            
            if (result.mGestureType == GestureAnalyzer.kGestureName_LongPress)
            {
               SetText ("Long pressed.");
               SetRecognizeResult (null);
               return;
            }
            
            var resultBitmap:Bitmap = null;
            switch (result.mGestureType)
            {
               case GestureAnalyzer.kGestureName_Line:
                  resultBitmap = new IconLine ();
                  break;
               case GestureAnalyzer.kGestureName_LineArrow:
                  resultBitmap = new IconLineArrow ();
                  break;
               case GestureAnalyzer.kGestureName_LineZigzag:
                  resultBitmap = new IconLineZigzag ();
                  break;
               case GestureAnalyzer.kGestureName_Arrow:
                  resultBitmap = new IconArrow ();
                  break;
               case GestureAnalyzer.kGestureName_Zigzag:
                  resultBitmap = new IconZigzag ();
                  break;
               case GestureAnalyzer.kGestureName_MirrorZigzag:
                  resultBitmap = new IconMirrorZigzag ();
                  break;
               case GestureAnalyzer.kGestureName_Wave:
                  resultBitmap = new IconWave ();
                  break;
               case GestureAnalyzer.kGestureName_Pool:
                  resultBitmap = new IconPool ();
                  break;
               case GestureAnalyzer.kGestureName_Triangle:
                  resultBitmap = new IconTriangle ();
                  break;
               case GestureAnalyzer.kGestureName_Circle:
                  resultBitmap = new IconCircle ();
                  break;
               case GestureAnalyzer.kGestureName_FivePointStar:
                  resultBitmap = new IconFivePointStar ();
                  break;
               default:
               {
                  SetText ("???????????????????");
                  SetRecognizeResult (null);
                  return;
               }
            }
            
            SetText ((result.mIsClockWise ? "CW" : "CCW") + ", angle: " + result.mGestureAngle.toFixed (0));
            SetRecognizeResult (resultBitmap, result.mGestureAngle);
         }
         
         mGestureAnalyzer = null;
      }
      
      private function RegisterGesturePoint (gestureAnalyzer:GestureAnalyzer, pixelX:Number, pixelY:Number):void
      {  
         if (gestureAnalyzer == null)
            return;
         
         var inchX:Number = pixelX;
         var inchY:Number = pixelY;
         var gesturePoint:GesturePoint = gestureAnalyzer.RegisterPoint (inchX, inchY, getTimer ());
         if (gesturePoint != null)
         {
            mPointLayer.graphics.beginFill(0x00FF00);
            mPointLayer.graphics.drawCircle(pixelX, pixelY, 6);
            mPointLayer.graphics.endFill();
            
            if (gesturePoint.mPrevPoint != null)
            {
               var lastPixelX:Number = gesturePoint.mPrevPoint.mX;
               var lastPixelY:Number = gesturePoint.mPrevPoint.mY;
               mLineLayer.graphics.lineStyle(0, 0x000000);
               mLineLayer.graphics.moveTo(lastPixelX, lastPixelY);
               mLineLayer.graphics.lineTo(pixelX, pixelY);
            }
         }
      }
   }
}
